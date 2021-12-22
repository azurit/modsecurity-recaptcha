function main(recaptcha_response)
	local api_server = "https://www.google.com/recaptcha/api/siteverify"
	local req_timeout = 5

	pcall(require, "m")
	local ok, request = pcall(require, "http.request")
	if not ok then
		m.log(2, string.format("reCAPTCHA ERROR: lua-http library not installed, please install it or disable this plugin: %s.", ok))
		return nil
	end
	local req = request.new_from_uri(api_server)
	req.headers:upsert(":method", "POST")
	req.headers:upsert("Content-Type", "application/x-www-form-urlencoded")
	req:set_body(string.format("secret=%s&response=%s&remoteip=%s", m.getvar("tx.recaptcha_secret_key", "none"), recaptcha_response, m.getvar("REMOTE_ADDR", "none")))
	local headers, stream = req:go(req_timeout)
	if headers == nil then
		m.log(2, "reCAPTCHA ERROR: Cannot connect to Google API.")
		return nil
	end
	local body, err = stream:get_body_as_string()
	if not body and err then
		m.log(2, string.format("reCAPTCHA ERROR: Cannot connect to Google API: %s.", err))
		return nil
	end
	if not body:find("\"success\": true,") then
		return "reCAPTCHA validation failed."
	end
	return nil
end
