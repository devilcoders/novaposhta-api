require "nokogiri/xml/sax/document"

module Novaposhta
  module Parser
    class WarehouseParser < Nokogiri::XML::SAX::Document
      def initialize
        @warehouses = []
        @current_warehouse = {}
        @warehouse_element = false
        @tag_content = ''
      end

      def warehouses
        return @warehouses
      end

      def start_element(name, attrs = [])
        return if name != "warenhouse" && !@warehouse_element
        case name
          when "warenhouse"
            @current_warehouse = {}
            @warehouse_element = true
          when "city"
            @tag_content = "city_ukr"
          when "cityRu"
            @tag_content = "city_ru"
          when "wareId"
            @tag_content = "id"
          when "address"
            @tag_content = "address_ukr"
          when "addressRu"
            @tag_content = "address_ru"
          when "weekday_reseiving_hours"
            @tag_content = "weekday_receiving_hours"
          when "saturday_reseiving_hours"
            @tag_content = "saturday_receiving_hours"
          else
            @tag_content = name
        end
      end

      def characters(string)
        return if @tag_content.empty?
        @current_warehouse[@tag_content.to_sym] = string
        @tag_content = ''
      end

      def end_element(name)
        if name == "warenhouse"
          @warehouse_element = false
          @warehouses << Novaposhta::Warehouse.new(@current_warehouse)
        end
      end
    end
  end
end