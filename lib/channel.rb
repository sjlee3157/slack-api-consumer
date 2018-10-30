# The Rails code using our API responses will need to know how the API formatted the data
# If the API changes, the way we use the formatted data will change
# This defeats the whole point of wrapping the API! Instead, let's build a Channel object to make life a little easier for someone (like us in 20 minutes). Note that the started file has been created for you in lib/channel.rb.
# A Channel should have a publicly visible name, as well as other fields we get back from the API.

class Channel
  attr_reader :name, :id, :purpose, :is_archived, :members

  def initialize(name, id, options = {} )
    raise ArgumentError if name == nil || name == "" || id == nil || id == ""

    @name = name
    @id = id

    @purpose = options[:purpose]
    @is_archived = options[:is_archived]
    @is_general = options[:is_archived]
    @members = options[:members]
  end
end
