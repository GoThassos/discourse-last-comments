# Discourse Last Comments Plugin

## Instalation

1. Install like any other plugin
2. Enable in plugin settings
3. Add your target domain in the allowed embed domains
4. Add this code to your site, changing the DiscourseEmbed settings

```JS
<div id='discourse-comments'></div>
<meta name='discourse-username' content='eviltrout'>

<script type="text/javascript">
  window.DiscourseEmbed = {
    discourseUrl: 'http://localhost:4200/',
    topicId: 3
  };

  (function () {
    var d = document.createElement('script'); d.type = 'text/javascript'; d.async = true;
    d.src = window.DiscourseEmbed.discourseUrl + 'plugins/discourse-last-comments/embed.js';
    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(d);
  })();
</script>
```

The only downside is because I used the same code but modified you can’t put one of these embeds and a regular discourse on on the same page
