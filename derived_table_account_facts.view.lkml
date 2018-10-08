# If necessary, uncomment the line below to include explore_source.
# include: "talkdesk.model.lkml"

view: account_facts {
  derived_table: {
    explore_source: calls_historical__account {
      column: account_id {}
      column: queue_service_level {}
      filters: {
        field: calls_historical__account.call_finished_time
        value: "2 days"
      }
    }
  }
  dimension: account_id {
    primary_key: yes
    hidden: yes
  }
  dimension: account_service_level {
    description: "Service Level calls belong to the queue, not a specific agent. Do not use with user_id dimension."
    value_format: "#.00\%"
    type: number
    sql: ${TABLE}.queue_service_level ;;
  }

}
