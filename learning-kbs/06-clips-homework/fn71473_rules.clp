; NOT-INCLUDE: Written in Bulgarian in order to generate the docs more easily.
;
; Следната система основана на знания има за цел да препоръчва книги на 
; определени типове хора.  Хората могат да са в три категории - бизнесмени,
; студенти или бедняци.  Всеки човек се определя от някакви полезни за него
; характеристики, на базата на които се прави заключение за това каква книга 
; би му била полезна.  Нормално е за някой тип хора, например студентите, 
; които не учат и ходят твърде често на партита, системата да не може да
; препоръча книга.  В крайна сметка, това не би направило щастливи този тип
; хора.
;
; Системата работи като първо определя какъв тип е човека:
; \begin{itemize}
;   \item determine-type - определя типа на човека; оттук стартираме
;   \item determine-business - доспецифицира бизнес човек
;   \item determine-student - доспецифицира студент
;   \item determine-poor - доспецифицира бедняк
; \end{itemize}
;
; След това, на базата на разни параметри от типа човек, системата определя
; каква книга да му препоръча:
; \begin{itemize}
;   \item suggest-book-poor - препоръчва книга на бедняк
;   \item suggest-book-working - препоръчва книга на работещ студент
;   \item suggest-book-studying - препоръчва книга на учещ студент
;   \item suggest-book-not-studying - препоърчва книга на неучещ студент
;   \item suggest-book-startup-founder - препоръчва книга на основател на стартъп
;   \item suggest-book-businessman - препоръчва книга на бизнесмен
; \end{itemize}
;

;
; От тук почва програмата.
; Опитваме се да определим прости факти за човека, а също така и какъв е по
; професия - Бедняк, Бизнесмен или Студент.
(defrule determine-type
  (initial-fact)
=>
  (printout t "What's your name?" crlf)
  (assert (name (read)))

  (printout t "What's your age?" crlf)
  (bind ?age (read))
  (if (and (>= ?age 2) (<= ?age 150))
      then
      (assert (age ?age))
      else
      (printout t "Age must be between 2 and 150" crlf)
      (return))

  (printout t "What's your gender: M/F?" crlf)
  (bind ?g (read))
  (if (or (eq ?g M) (eq ?g F))
      then
      (assert (gender ?g))
      else
      (printout t "Gender must be either M or F" crlf)
      (return))

  (printout t "What's your current occupation: Poor/Businessman/Student?" crlf)
  (bind ?o (read))
  (if (or (eq ?o Businessman) (eq ?o Poor) (eq ?o Student))
      then 
      (assert (occupation ?o))
      else
      (printout t "Occupation must be either Poor/Businessman/Student" crlf)
      (return))

  (assert (type-determined))
)

;
; Следващите функции са общи за някои правила.
;
; Определя какъв бизнес има даден човек.
(deffunction determine-business ()
  (printout t "What type of business do you have?" crlf)
  (printout t (slot-allowed-values Business type) crlf)
  (bind ?type (read))
  (if (not (member ?type (slot-allowed-values Business type)))
      then
      (printout t "Not in allowed types" crlf)
      (return))

  (printout t "What's your yearly income?" crlf)
  (bind ?yearlyIncome (read))
  (if (< ?yearlyIncome 0)
      then
      (printout t "Must be positive" crlf)
      (return))

  (make-instance b of Business
    (type ?type)
    (yearly-income ?yearlyIncome)
  )

  (return b)
)

;
; Следващите правила препоръчват книга на бизнесмен.
;
; Това правило дохарактеризира бизнесмен.
(defrule determine-businessman
  (occupation Businessman)
  (age ?a)
  (name ?n)
  (gender ?g)
  ?td <- (type-determined)
=>
  (printout t "How large is your network?" crlf)
  (bind ?ns (read))
  (if (< ?ns 0)
      then
      (printout t "Must be positive" crlf)
      (return))

  (bind ?b (determine-business))

  (make-instance bm of Businessman
    (age ?a)
    (name_ ?n)
    (gender ?g)
    (network_size ?ns)
    (business ?b))
  (assert (businessman bm))
)

; Тази функция определя евристиката за препоръчване на книга на бизнесмен.
(deffunction businessman-query (?b ?ns)
  (bind ?authenticity (send ?b get-authenticity))
  (bind ?difficulty (send ?b get-difficulty))
  (bind ?timeToRead (send ?b get-time-to-read))

  (< ?ns (* ?authenticity ?difficulty))
)

; Това правило препоръчва книга на бизнесмен на базата на евристиката
; `businessman-query`.
(defrule suggest-book-businessman
  (businessman bm)
=>
  (bind ?books (find-all-instances ((?b Book))
    (businessman-query ?b (send [bm] get-network_size))))
  (bind ?n (random 1 (length ?books)))

  (printout t "Possible books: " (length ?books) crlf)
  (send (nth$ ?n ?books) print)
)

;
; Следващите правила и функции препоръчват книга на студент.
;
; Тази функция има за цел да характеризира работещ студент.
(deffunction determine-working (?a ?n ?g ?uni ?yr ?deg)
  (printout t "How much free time do you have?" crlf)
  (bind ?ft (read))
  (if (not (and (>= ?ft 1) (<= ?ft 24)))
      then
      (printout t "Free time must be between 1 and 24" crlf)
      (return))
  
  (make-instance ws of Working
    (age ?a)
    (name_ ?n)
    (gender ?g)
    (university ?uni)
    (year ?yr)
    (degree ?deg)
    (free_time ?ft))
  (assert (working-student ws))
)

; Това е помощна функция за суперкласа `Ordinary` студент.
(deffunction determine-ordinary ()
  (printout t "How much time do you spend to party in a month?" crlf)
  (bind ?dt (read))
  (if (not (and (>= ?dt 0) (<= ?dt 672)))
      then
      (printout t "Must be in [0;672]" crlf)
      (return))

  (printout t "How much money per month do you have?" crlf)
  (bind ?mpm (read))
  (if (< ?mpm 1)
      then
      (printout t "Must be positive" crlf)
      (return))

  (return (create$ ?dt ?mpm))
)

; Тази функция определя учещ студент с помощта на `determine-ordinary`.
(deffunction determine-studying (?a ?n ?g ?uni ?yr ?deg)
  (bind ?ls (determine-ordinary))
  (bind ?dt (nth 1 ?ls))
  (bind ?mpm (nth 2 ?ls))

  (printout t "How much time do you spend studying [1:24]?" crlf)
  (bind ?tss (read))
  (if (not (and (>= ?tss 1) (<= ?tss 24)))
      then
      (printout t "Must be [1;24]" crlf)
      (return))

  (make-instance sts of Studying
    (age ?a)
    (name_ ?n)
    (gender ?g)
    (university ?uni)
    (year ?yr)
    (degree ?deg)
    (disco_time ?dt)
    (money_per_month ?mpm)
    (time_spent_studying ?tss))
  (assert (studying-student sts))
)

; Тази функция определя неучещ студент с помощта на `determine-ordinary`.
(deffunction determine-not-studying (?a ?n ?g ?uni ?yr ?deg)
  (bind ?ls (determine-ordinary))
  (bind ?dt (nth 1 ?ls))
  (bind ?mpm (nth 2 ?ls))

  (printout t "What's your speech skill (1 to 100)?" crlf)
  (bind ?ss (read))
  (if (not (and (>= ?ss 1) (<= ?ss 100)))
      then
      (printout t "Must be in [1;100]" crlf)
      (return))

  (printout t "How many exams do you have?" crlf)
  (bind ?ce (read))
  (if (< ?ce 0)
      then
      (printout t "Must be positive" crlf)
      (return))

  (make-instance nsts of NotStudying
    (age ?a)
    (name_ ?n)
    (gender ?g)
    (university ?uni)
    (year ?yr)
    (degree ?deg)
    (disco_time ?dt)
    (money_per_month ?mpm)
    (speech_skill ?ss)
    (count_exams ?ce))
  (assert (not-studying-student nsts))
)

; Тази функция определя основател на стартъп.
(deffunction determine-startup-founder (?a ?n ?g ?uni ?yr ?deg)
  (bind ?b (determine-business))

  (printout t "How much money are invested in your business?" crlf)
  (bind ?in (read))
  (if (< ?in 0) 
      then
      (printout t "Must be positive" crlf)
      (return))

  (printout t "How large is your network?" crlf)
  (bind ?ns (read))
  (if (< ?ns 0)
      then
      (printout t "Must be positive" crlf)
      (return))

  (make-instance sf of StartupFounder
    (age ?a)
    (name_ ?n)
    (gender ?g)
    (university ?uni)
    (year ?yr)
    (degree ?deg)
    (invested ?in)
    (business ?b)
    (network_size ?ns))
  (assert (startup-founder sf))
)

; В тази глобална променлива се държат възможните типове студенти с цел
; предоставянето на списък за избор на човека, на който се препоръчва книга.
(defglobal ?*student-types* = (create$ Studying NotStudying Working StartupFounder))

; Това правило дохарактеризира студент.
(defrule determine-student
  (occupation Student)
  (age ?a)
  (name ?n)
  (gender ?g)
  ?td <- (type-determined)
=>
  (printout t "What year are you?" crlf)
  (bind ?yr (read))
  (if (not (and (>= ?yr 1) (<= ?yr 8)))
      then
      (printout t "Year must be between 1 and 8" crlf)
      (return))

  (printout t "In which university are you?" crlf)
  (printout t (slot-allowed-values Student university) crlf)
  (bind ?uni (read))
  (if (not (member ?uni (slot-allowed-values Student university)))
      then
      (printout t "Uni not in allowed values" crlf)
      (return))

  (printout t "What degree are you pursuing?" crlf)
  (printout t (slot-allowed-values Student degree) crlf)
  (bind ?deg (read))
  (if (not (member ?deg (slot-allowed-values Student degree)))
      then
      (printout t "Degree not in allowed values" crlf)
      (return))

  (printout t "What type of student are you?" crlf)
  (printout t ?*student-types* crlf)
  (bind ?t (read))
  (if (not (member ?t ?*student-types*))
      then
      (printout t "Type not in allowed values" crlf)
      (return))

  (bind ?success 
    (switch ?t
      (case Working then (determine-working ?a ?n ?g ?uni ?yr ?deg))
      (case Studying then (determine-studying ?a ?n ?g ?uni ?yr ?deg))
      (case NotStudying then (determine-not-studying ?a ?n ?g ?uni ?yr ?deg))
      (case StartupFounder then (determine-startup-founder ?a ?n ?g ?uni ?yr ?deg))
      (default "none")))

  (if (neq ?success "none")
      then
      (retract ?td))
)

; Тази функция определя евристиката за препоръчване на книга 
; на работещ студент.
(deffunction working-query (?b ?year ?freetime) 
  (bind ?authenticity (send ?b get-authenticity))
  (bind ?difficulty (send ?b get-difficulty))
  (bind ?timeToRead (send ?b get-time-to-read))

  (and (> (* ?freetime 2.5) ?timeToRead)
       (< ?difficulty ?year))
)

; Това правило препоръчва книга на работещ студент на базата на евристиката
; `working-query`.
(defrule suggest-book-working-student
  (working-student ws)
=>
  (bind ?books (find-all-instances ((?b Book)) 
    (working-query ?b (send [ws] get-year) (send [ws] get-free_time))))
  (bind ?n (random 1 (length ?books)))

  (printout t "Possible books: " (length ?books) crlf)
  (send (nth$ ?n ?books) print)
)

; Тази функция определя евристиката за препоръчване на книга на
; учещ студент.
(deffunction studying-query (?b ?year ?timespentstudying)
  (bind ?authenticity (send ?b get-authenticity))
  (bind ?difficulty (send ?b get-difficulty))
  (bind ?timeToRead (send ?b get-time-to-read))

  (and (> (* (- 24 ?timespentstudying) 1.5) ?timeToRead)
       (< ?difficulty ?year))
)

; Това правило препоръчва книга на учещ студент на базата на евристиката
; `studying-query`.
(defrule suggest-book-studying-student
  (studying-student sts)
=>
  (bind ?books (find-all-instances ((?b Book)) 
    (studying-query ?b (send [sts] get-year) (send [sts] get-time_spent_studying))))
  (bind ?n (random 1 (length ?books)))

  (printout t "Possible books: " (length ?books) crlf)
  (send (nth$ ?n ?books) print)
)

; Тази функция определя евристиката за препоръчване на книга на
; неучещ студент.
(deffunction not-studying-query (?b ?year ?speechskill ?countexams)
  (bind ?authenticity (send ?b get-authenticity))
  (bind ?difficulty (send ?b get-difficulty))
  (bind ?timeToRead (send ?b get-time-to-read))

  (and (> (/ ?speechskill (/ ?countexams 20)) (* ?difficulty ?authenticity))
       (< ?difficulty ?year))
)

; Това правило препоръчва книга на неучещ студент на базата на евристиката
; `not-studying-query`.
(defrule suggest-book-not-studying-student
  (not-studying-student nsts)
=>
  (bind ?books (find-all-instances ((?b Book)) 
    (not-studying-query ?b (send [nsts] get-year) 
                           (send [nsts] get-speech_skill)
                           (send [nsts] get-count_exams))))
  (bind ?n (random 1 (length ?books)))

  (printout t "Possible books: " (length ?books) crlf)
  (send (nth$ ?n ?books) print)
)

; Тази функция определя евристиката за препоръчване на книга на
; основател на стартъп.
(deffunction startup-founder-query (?b ?year ?invested)
  (bind ?authenticity (send ?b get-authenticity))
  (bind ?difficulty (send ?b get-difficulty))
  (bind ?timeToRead (send ?b get-time-to-read))

  (and (< (* ?authenticity ?difficulty ?timeToRead) ?invested)
       (< ?difficulty ?year))
)

; Това правило препоръчва книга на основател на стартъп на базата на 
; евристиката `startup-founder-query`.
(defrule suggest-book-startup-founder
  (startup-founder sf)
=>
  (bind ?books (find-all-instances ((?b Book)) 
    (startup-founder-query ?b (send [sf] get-year)
                              (send [sf] get-invested))))
  (bind ?n (random 1 (length ?books)))

  (printout t "Possible books: " (length ?books) crlf)
  (send (nth$ ?n ?books) print)
)

;
; Следващите правила препоръчват книга на бедняк.
;
; Това правило характеризира бедняк.
(defrule determine-poor
  (occupation Poor)
  (age ?a)
  (name ?n)
  (gender ?g)
  ?td <- (type-determined)
=>
  (printout t "How many worries do you have?" crlf)
  (bind ?w (read))
  (if (numberp ?w)
      then
      (assert (worries ?w))
      else
      (printout t "Worries must be a number" crlf)
      (return))

  (printout t "How much debth do you have?" crlf)
  (bind ?d (read))
  (if (numberp ?d)
      then
      (assert (debth ?d)) 
      else
      (printout t "Debth must be a number" crlf)
      (return))

  (make-instance p of Poor
    (age ?a)
    (gender ?g)
    (name_ ?n)
    (worries ?w)
    (debth ?d))
  (assert (poor p))

  (retract ?td)
)

; Тази функция определя евристиката за препоръчване на книга на бедняк.
(deffunction poor-query (?b ?debth ?worries)
  (bind ?authenticity (send ?b get-authenticity))
  (bind ?difficulty (send ?b get-difficulty))
  (bind ?timeToRead (send ?b get-time-to-read))

  (and (<= ?timeToRead ?worries) 
       (<= (/ ?debth 1000) (* ?authenticity ?difficulty)))
)

; Това правило препоръчва книга на бедняк на базата на евристиката 
; `poor-query`.
(defrule suggest-book-poor
  (poor p)
=>
  (bind ?books (find-all-instances ((?b Book)) 
    (poor-query ?b (send [p] get-debth) (send [p] get-worries))))
  (bind ?n (random 1 (length ?books)))

  (printout t "Possible books: " (length ?books) crlf)
  (send (nth$ ?n ?books) print)
)
