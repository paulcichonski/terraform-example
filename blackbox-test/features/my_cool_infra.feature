Feature: my-cool-infra docker image should launch a webserver that says Hello World

  Scenario: Hello World
    Given terraform has created a vpc
    And terraform has created the webserver
    Then the webserver should be listening on port 80 within 120 seconds
    And the homepage should return "Hello World"
