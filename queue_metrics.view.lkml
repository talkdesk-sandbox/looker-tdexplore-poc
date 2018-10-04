view: queue_metrics {
  derived_table: {
    sql: SELECT
          account_id,
          talkdesk_phone_number,
          ring_group,
          call_finished,
          CASE WHEN in_business_hours AND last_call_state IN ('finished','missed') AND waiting_time <= service_level_threshold THEN 1 ELSE 0 END AS within_service_level,
          CASE WHEN in_business_hours AND last_call_state IN ('finished','missed') THEN 1 ELSE 0 END AS in_business_hours_fm
        FROM public.calls_historical
        WHERE
          direction = 'in'
        GROUP BY account_id, talkdesk_phone_number, ring_group, call_finished
        ;;
  }

  # Dimensions
  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: talkdesk_phone_number {
    type: string
    sql: ${TABLE}.talkdesk_phone_number ;;
  }

  dimension: ring_group {
    type: string
    sql: ${TABLE}.ring_group ;;
  }

  dimension_group: call_finished {
    type: time
    timeframes: [
      raw,
      time,
      minute,
      hour,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.call_finished ;;
  }

  parameter: timeframe_picker {
    label: "Date Granularity"
    description: "Use this with Call Finished Dynamic dimension"
    type: string
    allowed_value: { value: "Month" }
    allowed_value: { value: "Day" }
    allowed_value: { value: "Hour" }
    allowed_value: { value: "Minute" }
    default_value: "Hour"
  }

  dimension: call_finished_dynamic_v1 {
    description: "Use this with Date Granularity filter"
    type: date_time
    sql:
      CASE
      WHEN {% parameter timeframe_picker %} = 'Month' THEN DATE_TRUNC('month', ${call_finished_raw})
      WHEN {% parameter timeframe_picker %} = 'Day' THEN  ${call_finished_date}
      WHEN {% parameter timeframe_picker %} = 'Hour' THEN DATE_TRUNC('hour', ${call_finished_raw})
      WHEN {% parameter timeframe_picker %} = 'Minute' THEN DATE_TRUNC('minute', ${call_finished_raw})
      END ;;
  }

  dimension: call_finished_dynamic_v2 {
    description: "Use this with Date Granularity filter"
    type: string
    sql:
      CASE
      WHEN {% parameter timeframe_picker %} = 'Month' THEN ${call_finished_month}
      WHEN {% parameter timeframe_picker %} = 'Day' THEN  TO_CHAR(${call_finished_date}, 'YYYY-MM-DD')
      WHEN {% parameter timeframe_picker %} = 'Hour' THEN ${call_finished_hour}
      WHEN {% parameter timeframe_picker %} = 'Minute' THEN ${call_finished_minute}
      END ;;
  }

  #add this to call_finished_dynamic_v2
  #/*WHEN {% parameter timeframe_picker %} = 'Hour' THEN TO_CHAR(${call_finished_date}, 'YYYY-MM-DD') || ' ' || ${custom_hour_of_day}*/
  dimension: custom_hour_of_day {
    hidden: yes
    description: "Need to do this so it orders correctly when the dynamic timeframe is used in a report."
    sql: CASE
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 0 then '00'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 1 then '01'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 2 then '02'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 3 then '03'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 4 then '04'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 5 then '05'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 6 then '06'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 7 then '07'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 8 then '08'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 9 then '09'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 10 then '10'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 11 then '11'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 12 then '12'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 13 then '13'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 14 then '14'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 15 then '15'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 16 then '16'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 17 then '17'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 18 then '18'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 19 then '19'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 20 then '20'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 21 then '21'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 22 then '22'
            WHEN EXTRACT(HOUR FROM ${call_finished_raw} ) = 23 then '23'
          END
          ;;
  }

  # Measures
  measure: inbound_calls_during_business_hours_fm {
    hidden: yes
    type: sum
    sql: ${TABLE}.in_business_hours_fm ;;
  }

  measure: calls_with_waiting_time_less_that_service_level {
    hidden: yes
    type: sum
    sql: ${TABLE}.within_service_level ;;
  }

  measure: service_level {
    description: "Service Level calls belong to the queue, not a specific agent. Do not use with user_id dimension."
    type: number
    sql: (100.00 * COALESCE(${calls_with_waiting_time_less_that_service_level},0)) /NULLIF(${inbound_calls_during_business_hours_fm},0) ;;
    value_format: "#.00\%"
    html:   <img src="https://chart.googleapis.com/chart?chs=400x250&cht=gom&chma=10,0,0,0&chxt=y&chco=FF4E00,191F43,01C6CC&chf=bg,s,FFFFFF00&chl={{ rendered_value }}&chd=t:{{ value }}">;;
    # https://discourse.looker.com/t/creating-custom-vis-via-html/3735
  }

}
