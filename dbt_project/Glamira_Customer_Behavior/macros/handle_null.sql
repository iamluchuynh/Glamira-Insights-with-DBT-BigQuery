{% macro handle_null(field, default_value) %}
    COALESCE(CAST({{ field }} AS STRING), '{{ default_value }}')
{% endmacro %}