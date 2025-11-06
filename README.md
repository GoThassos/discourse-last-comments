# Discourse Last Comments Plugin

## Instalation

1. Install lkie any other plugin
2. Enable in plugin settings
3. Add your target domain in the allowed embed domains
4. Add this code to your site, chaniging the DiscourseEmbed settings

```JS
<script type="text/javascript">
  window.DiscourseEmbed = {
    discourseUrl: 'http://localhost:4200/',
    topicId: 3
  };

  (function () {
    var d = document.createElement('script'); d.type = 'text/javascript'; d.async = true;
    d.src = window.DiscourseEmbed.discourseUrl + 'plugins/discourse-last-comments/embed.js';
    (document.getElementsByTagName['head'](0) || document.getElementsByTagName['body'](0)).appendChild(d);
  })();
</script>
```
