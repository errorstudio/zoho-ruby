module Zoho
  module CRM
    class Contact < Base
      include Persistence
      collection_path "json/Contacts/getRecords"
      primary_key :contactid
      resource_path "json/Contacts/getRecordById?id=:contactid"

      def account=(account)
        self.accountid = account.id
      end

      def account
        Account.find(accountid)
      end

      # Zoho expects this:
      #
      # <Contacts>
      # <row no="1">
      # <FL val="First Name">Scott</FL>
      # <FL val="Last Name">James</FL>
      # <FL val="Email">test@test.com</FL>
      # <FL val="Department">CG</FL>
      # <FL val="Phone">989898988</FL>
      # <FL val="Fax">99999999</FL>
      # <FL val="Mobile">99989989</FL>
      # <FL val="Assistant">John</FL>
      # </row>
      # </Contacts>
      #
      DEFAULT_PARAMS = [
        :first_name,
        :last_name,
        :email,
        :department,
        :phone,
        :fax,
        :assistant,
        :accountid
      ]

      define_attribute_methods DEFAULT_PARAMS
    end
  end
end