require 'httparty'

# Verify it works through the rails console:
# SlackApiWrapper.send_msg("test-api-channel", "test test test")

class SlackApiWrapper
  BASE_URL = "https://slack.com/api/"
  TOKEN = ENV["SLACK_TOKEN"]

# Sends a GET request to the corresponding API end point
# Returns the results as an array
# Checking to see if there's anything in the channels list
# We don't do JSON.parse, because we're kind of parsing it here.
  def self.list_channels
    url = BASE_URL + "channels.list?" + "token=#{TOKEN}" + "&pretty=1&exclude_archived=1"
    data = HTTParty.get(url)
    channel_list = []
    if data["channels"]
      data["channels"].each do |channel_data|
        channel_list << create_channel(channel_data)
      end
    end
    return channel_list
  end

  def self.send_msg(channel, msg)
    puts "Sending message to channel #{channel}: #{msg}"

    url = BASE_URL + "chat.postMessage?" + "token=#{TOKEN}"
    response = HTTParty.post(url,
    body:  {
      "text" => "#{msg}",
      "channel" => "#{channel}",
      "username" => "sambot jobot",
      "icon_emoji" => ":beetle:",
      "as_user" => "false"
    },
    :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' })
                                    # Postman is adding this header for us.
                                    # In Postman, click on Body tab.
                                    # Find this in the API documentation.
                                    # This tells the reader how to parse it.
                                    # Sometimes, or maybe in the future,
                                    # this is going to be a different format.
    return response.success?
  end

  private

# Concentrate all the logic that relies on the specific Slack API channel data
# in a single method here.
# ( If the data in the API response changes,
# this will be the only method we need to update.)
  def self.create_channel(api_params)
    return Channel.new(
      api_params["name"],
      api_params["id"],
      {
        purpose: api_params["purpose"],
        is_archived: api_params["is_archived"],
        members: api_params["members"]
      }
    )
  end

end
