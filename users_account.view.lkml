view: users_account {
  derived_table: {
    sql: select
        account_id
        , user_id
        , user_name
      from public.agent_status_live
      where account_id = '{{ _user_attributes['account_id_manual'] }}'
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension:account_id  {
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
    link: {
      label: "Agent Details"
      url: "https://talkdeskoem.eu.looker.com/dashboards/3?UserID={{ value }}"
    }
  }

  dimension: user_name {
    type: string
    sql: ${TABLE}.user_name ;;
  }

  set: detail {
    fields: [account_id, user_id, user_name]
  }
}
