<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-{{ theme.authoricon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>
  <span class="with-love">
      <i class="fa fa-{{ theme.authoricon }}"></i>
    </span>
  <span class="author">
    {{ __('鄂ICP备') }} -
    <a class="theme-link" href="http://www.miitbeian.gov.cn/">18004935号</a>
  </span>
</div>
