class MemberIdentity < OmniAuth::Identity::Models::ActiveRecord
  self.table_name = "identities"
end
