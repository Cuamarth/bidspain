ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }
  
  

  content :title => proc{ I18n.t("active_admin.dashboard") } do
     columns do
       column do
         panel "Ultimos usuarios registrados" do
           ul do
             User.page(1).per(10).order('created_at DESC').map do |user|
               li simple_format("<strong>"+user.created_at.to_formatted_s(:short) +"</strong>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+ user.username+"  ----  "+user.fullName )
             end
           end
         end

       end
       


       column do
         panel "Resumen de ingresos" do
           ul do
           
          # li  "Ultimo mes :"+ Payorder.where(updated_at>1.month.ago,status: "2").sum('money')           
           li "Semana actual :"+number_to_currency(Payorder.where("status=? and created_at >= ? and created_at <= ?", "1",Time.now.beginning_of_week,Time.now.end_of_week).sum("money"))
           li "Semana anterior :"+number_to_currency(Payorder.where("status=? and created_at >= ? and created_at <= ?", "1",1.week.ago.beginning_of_week,1.week.ago.end_of_week).sum("money"))
           li "Mes actual  :"+number_to_currency(Payorder.where("status=? and created_at >= ? and created_at <= ?", "1",Time.now.beginning_of_month,Time.now.end_of_month).sum("money"))
           li "Mes anterior:"+number_to_currency(Payorder.where("status=? and created_at >= ? and created_at <= ?", "1",1.month.ago.beginning_of_month,1.month.ago.end_of_month).sum("money"))
           li simple_format("Ultimo a&nacute;o :"+number_to_currency((Payorder.where("status=? and created_at >= ? and created_at <= ?", "1",Time.now.beginning_of_year,Time.now.end_of_year).sum("money"))))
           end
         end
         panel "Ultimas pujas" do
           ul do
             Bet.page(1).per(10).order('created_at DESC').map do |bet|
               li simple_format("<strong>"+bet.created_at.to_formatted_s(:short) +"</strong>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+ bet.user.username+"  ----  "+bet.bid.product.title )
             end
           end
         end

       end
     end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
