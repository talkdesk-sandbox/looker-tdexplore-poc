#Service Level
include: "*.view"
view: calls_historical__account {
  extends: [calls_historical__base]

  dimension: service_level_threshold {
    type: number
    sql: ${TABLE}.service_level_threshold ;;
  }

  measure: calls_with_waiting_time_less_that_service_level {
    hidden: yes
    type: sum
    sql: CASE WHEN ${waiting_time} <= ${service_level_threshold} THEN 1 ELSE NULL END ;;
    filters: {
      field: direction
      value: "in"
    }
    filters: {
      field: last_call_state
      value: "Finished,Missed"
    }
    filters: {
      field: in_business_hours
      value: "true"
    }
  }

  measure: service_level {
    description: "Service Level calls belong to the queue."
    type: number
    sql: (100.00 * COALESCE(${calls_with_waiting_time_less_that_service_level},0)) /NULLIF(${inbound_calls_during_business_hours_fm},0) ;;
    value_format: "#.00\%"
    drill_fields: [detail*]
    html:   <div align="left"><p style="font-family: Helvetica, Ariel; color: #727273; font-size: 1.2em; background-color:#FFFFFF;margin: auto; padding:.2em 0em;">{{ value }}</p></div> ;;

  }


}
