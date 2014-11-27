class MemberIdentity < OmniAuth::Identity::Models::ActiveRecord
  self.table_name = "member_identities"
end
