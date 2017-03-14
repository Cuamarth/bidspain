class ProductsController < ApplicationController

      def available_products
        @products=Product.all
        respond_to do |format|
            format.html {render :layout => false}            
        end 
      end
      
      def show 
        @product=Product.find(params[:id])
        respond_to do |format|
          format.json {render json:@product}
        end         
      end

end
