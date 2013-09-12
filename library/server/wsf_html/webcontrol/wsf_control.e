note
	description: "Summary description for {WSF_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_CONTROL

inherit

	WSF_STATELESS_CONTROL
		redefine
			render_tag_with_tagname
		end

feature

	control_name: STRING

feature {NONE}

	make_control (n, a_tag_name: STRING)
		do
			make (a_tag_name)
			control_name := n
			create state_changes.make
		ensure
			attached state_changes
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	load_state (new_states: JSON_OBJECT)
			-- Select state stored with `control_name` as key
		do
			if attached {JSON_OBJECT} new_states.item (create {JSON_STRING}.make_json (control_name)) as new_state_obj then
				set_state (new_state_obj)
			end
		end

	set_state (new_state: JSON_OBJECT)
			-- Before we process the callback. We restore the state of control.
		deferred
		end

	read_state (states: JSON_OBJECT)
			-- Add a new entry in the `states` JSON object with the `control_name` as key and the `state` as value
		do
			states.put (state, create {JSON_STRING}.make_json (control_name))
		end

	read_state_changes (states: JSON_OBJECT)
			-- Add a new entry in the `states_changes` JSON object with the `control_name` as key and the `state` as value
		do
			if state_changes.count > 0 then
				states.put (state_changes, create {JSON_STRING}.make_json (control_name))
			end
		end

	state: JSON_OBJECT
			-- Returns the current state of the Control as JSON. This state will be transfered to the client.
		deferred
		end

	state_changes: JSON_OBJECT

feature -- Rendering

	render_tag_with_tagname (tag, body, attrs, css_classes_string: STRING): STRING
		local
			l_attributes: STRING
		do
			l_attributes := attrs
			if not css_classes_string.is_empty then
				l_attributes := l_attributes + " class=%"" + css_classes_string + "%""
			end
			Result := "<" + tag + " id=%"" + control_name + "%" data-name=%"" + control_name + "%" data-type=%"" + generator + "%" " + l_attributes
			if body.is_empty and not tag.is_equal ("textarea") then
				Result := Result + " />"
			else
				Result := Result + " >" + body + "</" + tag + ">"
			end
		end

feature --EVENT HANDLING

	handle_callback (cname: STRING; event: STRING)
			-- Method called if any callback received. In this method you can route the callback to the event handler
		deferred
		end

end
