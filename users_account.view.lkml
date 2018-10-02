include: "calls_historical.view"
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
  }

  dimension: user_name {
    type: string
    sql: ${TABLE}.user_name ;;
    link: {
      label: "Agent Details Dashboard"
      url: "https://talkdeskoem.eu.looker.com/dashboards/3?User ID={{ user_id._value }}&Date%20Status={{ _filters['calls_historical.call_finished_date'] }}&Date%20Calls={{ _filters['calls_historical.call_finished_date'] }}"
    }
  }

#   dimension: link_to_details {
#     type: string
#     sql:'Details' ;;
#     html: <a href="/dashboards/3?User ID={{ user_id._value }}" target="_new">Details</a> ;;
#   }

  set: detail {
    fields: [account_id, user_id, user_name]
  }
}
