view: agent_status_historical {
  derived_table: {
    sql: SELECT date_time, id, account_id, user_id, base_status, sum(new_status_duration_minutes) status_duration_per_minute
      FROM (
        SELECT time_series.*
        , CASE WHEN agent.status_started <= time_series.date_time THEN
              CASE WHEN agent.status_finished >= (time_series.date_time + INTERVAL '1 minute') THEN 60
              ELSE
                (DATE_PART('day', agent.status_finished - time_series.date_time) * 24 +
                 DATE_PART('hour', agent.status_finished - time_series.date_time) * 60 +
                 DATE_PART('minute', agent.status_finished - time_series.date_time) * 60 +
                 DATE_PART('second', agent.status_finished - time_series.date_time))
              END
          ELSE
              CASE WHEN agent.status_finished >= (time_series.date_time + INTERVAL '1 minute') THEN
                (DATE_PART('day', time_series.date_time + INTERVAL '1 minute' - agent.status_started) * 24 +
                 DATE_PART('hour', time_series.date_time + INTERVAL '1 minute' - agent.status_started) * 60 +
                 DATE_PART('minute', time_series.date_time + INTERVAL '1 minute' - agent.status_started) * 60 +
                 DATE_PART('second', time_series.date_time + INTERVAL '1 minute' - agent.status_started))
              ELSE
                (DATE_PART('day', agent.status_finished - agent.status_started) * 24 +
                 DATE_PART('hour', agent.status_finished - agent.status_started) * 60 +
                 DATE_PART('minute', agent.status_finished - agent.status_started) * 60 +
                 DATE_PART('second', agent.status_finished - agent.status_started))
              END
          END AS new_status_duration_minutes
        , agent.*
        FROM (
          SELECT id, account_id, user_id, status_started, status_finished, status_duration, base_status, status
          FROM public.agent_status_historical
          WHERE account_id = '{{ _user_attributes['account_id_manual'] }}'
            AND {% condition user_id_parameter %} user_id {% endcondition %}
            AND status_started <= CASE WHEN {% date_end date_filter %} IS NULL THEN NOW() ELSE {% date_end date_filter %}::timestamp END
            AND status_finished >= CASE WHEN {% date_start date_filter %} IS NULL THEN (NOW() - INTERVAL ' 732 day')::timestamp ELSE {% date_start date_filter %}::timestamp END
        ) AS agent
        INNER JOIN (
          -- For 2 year of data
          SELECT generate_series(CASE WHEN {% date_start date_filter %} IS NULL THEN (NOW() - INTERVAL ' 732 day')::timestamp ELSE {% date_start date_filter %}::timestamp END,CASE WHEN {% date_end date_filter %} IS NULL THEN NOW()::timestamp ELSE {% date_end date_filter %}::timestamp END, '1 minute')::timestamp AS date_time
        ) AS time_series ON time_series.date_time BETWEEN agent.status_started AND agent.status_finished
      ) AS status_per_minute
      GROUP BY 1, 2, 3, 4, 5
       ;;
  }

  dimension_group: date_time {
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
    sql: ${TABLE}.date_time ;;
  }

  parameter: timeframe_picker {
    label: "Date Granularity"
    description: "Use this with Status Finished Dynamic dimension"
    type: string
    allowed_value: { value: "Month" }
    allowed_value: { value: "Day" }
    allowed_value: { value: "Hour" }
    allowed_value: { value: "Minute" }
    default_value: "Hour"
  }

  dimension: date_time_dynamic {
    description: "Use this with Date Granularity filter"
    type: string
    sql:
    CASE
    WHEN {% parameter timeframe_picker %} = 'Month' THEN ${date_time_month}
    WHEN {% parameter timeframe_picker %} = 'Day' THEN  TO_CHAR(${date_time_date}, 'YYYY-MM-DD')
    WHEN {% parameter timeframe_picker %} = 'Hour' THEN ${date_time_hour}
    WHEN {% parameter timeframe_picker %} = 'Minute' THEN ${date_time_minute}
    END ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: base_status {
    type: string
    sql: ${TABLE}.base_status ;;
  }

  measure: status_duration_per_minute {
    type: sum
    sql: ${TABLE}.status_duration_per_minute / 86400.0 ;;
    value_format: "[h]:mm:ss"
  }

  filter: user_id_parameter {
    type: string
  }

  filter: date_filter {
    type: date
  }

  set: detail {
    fields: [date_time_time, id, user_id, base_status, status_duration_per_minute]
  }
}
