# fluent-plugin-filecount

[Fluentd](https://fluentd.org/) input plugin

Fluentd input plugin that recursively counts the number of files in directories.

## Requirements

This plugin uses `bash` for file expansion and `find` for searching.

## Installation

### RubyGems

```
$ gem install fluent-plugin-filecounts
```
### Fluentd

```
$ fluent-gem install fluent-plugin-filecounts
```
### Td-Agent

```
$ td-agent-gem install fluent-plugin-filecounts
```

## Configuration

## Fluent::Plugin::FilecountsInput

### tag (string) (required)

The tag of the event.

### path (string) (required)

The path to monitor

### interval (time) (required)

The interval time between periodic request

## Plugin helpers

* [timer](https://docs.fluentd.org/v1.0/articles/api-plugin-helper-timer)

* See also: [Input Plugin Overview](https://docs.fluentd.org/v1.0/articles/input-plugin-overview)

## Example

### Config
```
<source>
  @type filecounts
  path '/filestore/{documents,projects}/*'
  tag filecounts
  interval 60s
</source>
```

### Output
```
2018-12-14 08:15:35.633988091 -0800 filecounts: {"command":"bash -c '\\find /filestore/{documents,projects}/* -name \".*\" -prune -o -print'","time_to_run":18,"host":"myhost"}
2018-12-14 08:15:36.313656422 -0800 filecounts: {"path":"/filestore/documents","count":15,"host":"myhost"}
2018-12-14 08:15:36.313656422 -0800 filecounts: {"path":"/filestore/projects","count":3,"host":"myhost"}
2018-12-14 08:15:36.313656422 -0800 filecounts: {"path":"/filestore/projects/fluent","count":15,"host":"myhost"}
2018-12-14 08:15:36.313656422 -0800 filecounts: {"path":"/filestore/projects/ruby","count":32,"host":"myhost"}
2018-12-14 08:15:36.313656422 -0800 filecounts: {"path":"/filestore/projects/python","count":1,"host":"myhost"}
```

## Copyright

* Copyright(c) 2018- Zsolt Fekete
* License
  * Apache License, Version 2.0
