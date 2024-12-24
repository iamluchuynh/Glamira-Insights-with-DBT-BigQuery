{% macro generate_surrogate_key(columns) %}
md5(concat({{ ", ".join(columns) }}))
{% endmacro %}
