require 'attributes/uuid'
require 'attributes/concern/uuid'

ActiveRecord::Type.register(:uuid, UUID)

if defined? ActiveRecord::Base
  ActiveRecord::Base.include Attributes::Concern::UUID
end
