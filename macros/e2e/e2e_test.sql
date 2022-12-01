{% macro e2e_test(table_name) %} 
    {% if var("source_for_gf_raw") | trim | lower == var("source_for_test_data") %}
    
        WITH test AS ( 
            {% set expected_cases %}
            select 
            * 
        from {{ ref('expected_'+table_name)}}
            {% endset %}

            {% set actual_cases %}
                select 
            * 
        from {{ ref(table_name)}}
            {% endset %}

            {{ audit_helper.compare_queries(
                a_query=expected_cases,
                b_query=actual_cases
            ) }}
        )
        /*  when expected_cases and actual_cases differ anyhow, test fails */
        SELECT *
        FROM test 
        WHERE in_a = FALSE OR in_b=FALSE 

    {% else %}

        {# just pass #}
        select * 
        where 1=0

    {% endif %}
{% endmacro %}