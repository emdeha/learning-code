LIBS=-lrt -ldl -lm -pthread -lcurl
UV_PATH=uv/.libs/libuv.a

webserver: webserver.c uv/uv.a
	gcc -o webserver webserver.c $(UV_PATH) $(LIBS)

uvcat: uvcat.c uv/uv.a
	gcc -o uvcat uvcat.c $(UV_PATH) $(LIBS)

uvtee: uvtee.c uv/uv.a
	gcc -o uvtee uvtee.c $(UV_PATH) $(LIBS)

uvchange: uvchange.c uv/uv.a
	gcc -o uvchange uvchange.c $(UV_PATH) $(LIBS)

uv/uv.a:
	$(MAKE) -C uv
