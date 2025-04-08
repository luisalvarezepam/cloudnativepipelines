app_monitoring = {
    appinsightactions     = [
        {
            rg_name          = "#{ENV_MONITOR_RG}#"
            appinsights_name = "#{ENV_INFRA_SO_NAME}#-appins-#{ENV_INFRA_LOCATION_SHORT}#-#{ENV_INFRA_TYPE}#-#{ENV_INFRA_NAME_PREFIX}#-01"
            web_tests        = [
                {
                    name                    = "todoapp-availability-#{ENV_NAME}#"
                    kind                    = "ping"
                    description             = "Application availability test"
                    geo_locations           = ["us-il-ch1-azr","apac-jp-kaw-edge","emea-ch-zrh-edge","us-fl-mia-edge","latam-br-gru-edge"]
                    frequency               = 300
                    url                     = "https://#{SYS_PROJECT_CODE}#-#{ENV_INFRA_NAME_PREFIX}#-#{ENV_NAME}#.#{ENV_INFRA_LOCATION}#.cloudapp.azure.com/"
                    timeout                 = 60
                    enabled                 = true
                    expected_status_code    = 200
                    configuration           = <<XML
                                              <WebTest Name="test" Enabled="True" CssProjectStructure="" CssIteration="" Timeout="120" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description="" CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False" RecordedResultFile="" ResultsLocale="">
                                              <Items>
                                                  <Request Method="GET" Version="1.1" Url="https://#{SYS_PROJECT_CODE}#-#{ENV_INFRA_NAME_PREFIX}#-#{ENV_NAME}#.#{ENV_INFRA_LOCATION}#.cloudapp.azure.com/" ThinkTime="0" Timeout="120" ParseDependentRequests="False" FollowRedirects="True" RecordResult="True" Cache="False" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="200" ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />
                                              </Items>
                                              </WebTest>
                                              XML
                }
            ]
        }
    ]
    monitor_action_groups = [
        {
            action_group_name       = "app_alert_recievers_#{ENV_NAME}#"
            action_group_short_name = "appsql#{ENV_NAME}#"
            rg_name                 = "#{ENV_MONITOR_RG}#"
            email_receiver          = [
                {
                    name                    = "notify_#{ENV_APP_ALERTS_RECEIVERS_EMAIL}#"
                    email_address           = "#{ENV_APP_ALERTS_RECEIVERS_EMAIL}#"
                    use_common_alert_schema = true
                }
            ]
        }
    ]
    alerts   = [
        {
            action_group_rg_name = "#{ENV_MONITOR_RG}#"
            action_group_name    = "app_alert_recievers_#{ENV_NAME}#"
            metric_alert         = [
                {
                    name                = "app-avaliability_#{ENV_NAME}#"
                    metric_alert_scopes = ["/subscriptions/#{ENV_AZURE_SUBSCRIPTION_ID}#/resourceGroups/#{ENV_MONITOR_RG}#/providers/Microsoft.Insights/components/#{ENV_APPINS_NAME}#"]
                    description         = "Alerts when application is unavalible"
                    frequency           = "PT1M"
                    severity            = 1
                    window_size         = "PT5M"
                    criteria            = [
                        {
                            metric_namespace = "microsoft.insights/components"
                            metric_name      = "availabilityResults/availabilityPercentage"
                            aggregation      = "Average"
                            operator         = "LessThan"
                            threshold        = "100"
                            dimension        = [
                                {
                                    name     = "availabilityResult/name"
                                    operator = "Include"
                                    values   = [ "*" ]
                                }
                             ]
                        }
                    ]
                }
            ]
        }
    ]
}