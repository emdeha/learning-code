<post-text>

  <ul>
    <li each={ posts }>
      <label>{ content }</label>
      <br><br>
      <button onclick={ toggle }>View</button>
      <button class="danger" onclick={ removePost }>Remove</button>
      <br><br>
      <textarea name="view" hide={ isHidden } rows="4" cols="50" onkeyup={ editPost }>{ content }</textarea>
    </li>
  </ul>

  <hr if={ posts.length > 0 }>

  <form onsubmit={ addPost }>
    <textarea name="post" rows="4" cols="50" onkeyup={ edit }></textarea>
    <br><br>
    <button disabled={ !text }>Post</button>
  </form>

  <script>
    this.posts = opts.posts || []

    edit(e) {
      this.text = e.target.value
    }

    removePost(e) {
     var item = e.item
     var idx = this.posts.indexOf(item)
     this.posts.splice(idx, 1)
    }

    editPost(e) {
      var item = e.item
      var index = this.posts.indexOf(item)

      this.text = e.target.value
      this.posts[index].editContent = this.text
    }

    addPost(e) {
      if (this.text) {
        this.posts.unshift({ content: this.text, isHidden: true })
        this.text = this.post.value = ''
      }
    }

    toggle(e) {
      var item = e.item
      item.isHidden = !item.isHidden
      if (item.editContent) {
        item.content = item.editContent
      }
      return true
    }
  </script>

</post-text>
