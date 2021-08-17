-- Byte to hex converter
local function template_to_hex(c)
    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
    return string.format('%x', v)
end


-- Get header first value
local function get_header(headers, name)
    if headers ~= nil and name ~= nil and headers[name] ~= nil and headers[name][0] ~= nil then
        return headers[name][0]
    end
    return nil
end


-- Tracecontext request handler
local function tracecontext_req(txn)
    local headers = txn.http:req_get_headers()
    local traceparent = get_header(headers, 'traceparent')
    local tracestate = get_header(headers, 'tracestate')

    if traceparent == nil then
        traceparent = string.gsub('00-xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx-xxxxxxxxx4xxxyxx-01', '[xy]', template_to_hex)
        txn.http:req_set_header('traceparent', traceparent)
    end

    txn:set_var('txn.traceparent', traceparent)
    txn:set_var('txn.tracestate', tracestate)
end


-- Tracecontext response handler
local function tracecontext_res(txn)
    txn.http:res_set_header('traceparent', txn:get_var('txn.traceparent'))
    txn.http:res_set_header('tracestate', txn:get_var('txn.tracestate'))
end


-- Init random
math.randomseed(os.time())


-- Register actions
core.register_action('tracecontext', {'http-req'}, tracecontext_req, 0)
core.register_action('tracecontext', {'http-res'}, tracecontext_res, 0)
