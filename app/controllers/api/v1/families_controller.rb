module Api
  module V1
    class FamiliesController < ApiController
      def index
        messages = init_messages
        if @current_user && @current_user.admin?
          @families = Family.all
          render :json => { :families => @families, :messages => messages }, :status => 200
        else
          messages[:error] << 'You are not authorized to do this.'
          render :json => { :messages => messages }, :status => 403
        end
      end

      def show
        messages = init_messages
        begin
          @family = Family.find(params[:id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family)
            render :json => { :family => @family, :messages => messages }, :status => 200
          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end

      def update
        messages = init_messages
        begin
          @family = Family.find(params[:id])
          if @current_user.try(:admin) || (@current_member.try(:family) == @family)
            @family.default_screen_time = params["default_time"].to_i if params["default_time"]
            @family.default_filter = params["default_filter"].downcase if params["default_filter"]
            @family.name = params["name"] if params["name"]
            if params[ "device_categories" ].present? &&  params[ "device_categories" ].is_a?(Hash)
              params[ "device_categories" ].each do |key, value|
                unless key.ends_with?('_other')
                  id = "#{key}"
                  id.slice!('device_category_')
                  device_category = FamilyDeviceCategory.find_or_create_by(device_category_id: id.to_i, family_id: @family.id)
                  if value.to_i != 4
                    device_category.amount = value.to_i
                  else
                    device_category.amount = params[ "device_categories" ][ "device_category_#{id}_other"].to_i
                  end
                  device_category.save
                  logger.info "Saved device category: #{device_category.inspect}"
                end
              end
            end

            if @family.save
              render :json => { :family => @family, :messages => messages }, :status => 200
            else
              @family.errors.each do |err|
                messages[:error] << err
              end
              render :json => { :family => @family, :messages => messages }, :status => 409
            end

          else
            messages[:error] << 'You are not authorized to do this.'
            render :json => { :messages => messages }, :status => 403
          end

        rescue ActiveRecord::RecordNotFound
          messages[:error] << 'Family not found.'
          render :json => { :messages => messages }, :status => 404
        rescue
          messages[:error] << 'A server error occurred.'
          render :json => { :messages => messages }, :status => 500
        end

      end
    end
  end
end
