# haproxy-w3c-tracecontext

Generates *traceparent* header if missing. Makes *traceparent* and *tracestate* available for logging.

## Usage

Load the *tracecontext.lua* file via the `load-lua` directive in the `global` section of your HAProxy configuration:

```
global
    lua-load /path/to/tracecontext.lua

frontend text
  ...
  # Log format - add tracecontext info to default http log pattern
    log-format "%ci:%cp [%tr] (%[var(txn.traceparent)]) (%[var(txn.tracestate)]) %ft %b/%s %TR/%Tw/%Tc/%Tr/%Ta %ST %B %CC %CS %tsc %ac/%fc/%bc/%sc/%rc %sq/%bq %hr %hs %{+Q}r"
  ...
  # Generate traceparent if missing and set tracecontext available for logging
  http-request lua.tracecontext
  ...
  # (optional) Add tracecontext to response as headers
  http-response lua.tracecontext
```
