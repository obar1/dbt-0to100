{% macro ref(model_name) %}

{%- set rel = builtins.ref(model_name) -%}
{%- if rel.identifier.lower().startswith('raw_') -%}

    {{ log("LOG: rel " ~ rel  , info=true) }}

    {%- if target.name == "gf" -%}
    {# prod env #}
    {%- set new_rel = adapter.get_relation(
        database=rel.database,
        schema=target.schema ~ '_raw',
        identifier=rel.identifier,
    ) -%}
    {{ log("LOG: new_rel " ~ new_rel ~ " target.name " ~ target.name, info=true) }}
    {% do return(new_rel) %}

    {%- elif target.name == "qa" -%}
    {# qa env #}
    {%- set new_rel = adapter.get_relation(
        database=rel.database,
        schema=target.schema ~ '_test_data',
        identifier='qa_' ~ rel.identifier,
    ) -%}
    {{ log("LOG: new_rel " ~ new_rel ~ " target.name " ~ target.name, info=true) }}
    {% do return(new_rel) %}

    {%- elif var("source_gf_raw_for_dev") | trim | lower == 'test_data' -%}
    {# dev using qa seeds #}
    {%- set new_rel = adapter.get_relation(
        database=rel.database,
        schema=target.schema ~ '_test_data',
        identifier='qa_' ~ rel.identifier,
    ) -%}
    {{ log("LOG: new_rel " ~ new_rel ~ " source_gf_raw_for_dev " ~ var("source_gf_raw_for_dev"), info=true) }}
    {% do return(new_rel) %}

    {%- elif var("source_gf_raw_for_dev") | trim | lower == 'gf_raw' -%}
    {# dev using gf_raw tables #}
    {%- set new_rel = adapter.get_relation(
        database=rel.database,
        schema='gf_raw',
        identifier=rel.identifier,
    ) -%}
    {{ log("LOG: new_rel " ~ new_rel ~ " source_gf_raw_for_dev " ~ var("source_gf_raw_for_dev"), info=true) }}
    {% do return(new_rel) %}

    {%- else -%}
        {% if execute %}
            {{ exceptions.raise_compiler_error("Check the code...") }}
        {% endif %}
    {%- endif -%}

{% else %}
    {% do return(rel) %}
{% endif %}

{% endmacro %}