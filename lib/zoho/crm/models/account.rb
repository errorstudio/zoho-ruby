module Zoho
  module CRM
    class Account < Base
      include Persistence
      collection_path "json/Accounts/getRecords"
      primary_key :accountid
      resource_path "json/Accounts/getRecordById?id=:accountid"

      # Zoho expects this:
      #
      # <Accounts>
      # <row no="1">
      # <FL val="Account Name">Zillum</FL>
      # <FL val="Website">www.zillum.com</FL>
      # <FL val="Employees">200</FL>
      # <FL val="Ownership">Private</FL>
      # <FL val="Industry">Real estate</FL>
      # <FL val="Fax">99999999</FL>
      # <FL val="Annual Revenue">20000000</FL>
      # </row>
      # </Accounts>
      #
      DEFAULT_PARAMS = [
        :account_name,
        :website,
        :ownership,
        :industry,
        :fax,
        :annual_revenue
      ]

      define_attribute_methods DEFAULT_PARAMS



     

    end
  end
end