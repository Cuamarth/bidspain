ActiveAdmin.register_page "Pujas" do

  menu :priority => 2, :label => proc{ "Pujas" }
  
  

  content :title => proc{ I18n.t("active_admin.dashboard") } do
     columns do
       column do

         panel "Usuarios con mas pujas esta semana" do
           ul do
             Bet.getMaxBettersByRange(Time.now.beginning_of_week,Time.now.end_of_week)[0..10].each do |u|
               li simple_format("<strong>"+u.betsdone.to_s+": </strong>&nbsp;&nbsp;&nbsp; "+u.fullName+"&nbsp;&nbsp; ( "+u.username+" )")
             end
           end
         end
         panel "Usuarios con mas pujas este mes" do
           ul do
             Bet.getMaxBettersByRange(Time.now.beginning_of_month,Time.now.end_of_month)[0..10].each do |u|
              li simple_format("<strong>"+u.betsdone.to_s+": </strong>&nbsp;&nbsp;&nbsp; "+u.fullName+"&nbsp;&nbsp; ( "+u.username+" )")             
             end
           end
         end
         panel "Usuarios con mas pujas este anyo" do
           ul do
             Bet.getMaxBettersByRange(Time.now.beginning_of_year,Time.now.end_of_year)[0..10].each do |u|
               li simple_format("<strong>"+u.betsdone.to_s+": </strong>&nbsp;&nbsp;&nbsp; "+u.fullName+"&nbsp;&nbsp; ( "+u.username+" )")
             end
           end
         end

       end
       


       column do
         panel "Usuarios con mas pujas la  semana pasada" do
           ul do
             Bet.getMaxBettersByRange(1.week.ago.beginning_of_week,1.week.ago.end_of_week)[0..10].each do |u|
              li simple_format("<strong>"+u.betsdone.to_s+": </strong>&nbsp;&nbsp;&nbsp; "+u.fullName+"&nbsp;&nbsp; ( "+u.username+" )")             
             end
           end
         end

         panel "Usuarios con mas pujas el mes pasado" do
           ul do
             Bet.getMaxBettersByRange(1.month.ago.beginning_of_month,1.month.ago.end_of_month)[0..10].each do |u|
              li simple_format("<strong>"+u.betsdone.to_s+": </strong>&nbsp;&nbsp;&nbsp; "+u.fullName+"&nbsp;&nbsp; ( "+u.username+" )")             
             end
           end
         end
         panel "Usuarios con mas pujas el anyo pasado" do
           ul do
             Bet.getMaxBettersByRange(1.year.ago.beginning_of_year,1.year.ago.end_of_year)[0..10].each do |u|
               li simple_format("<strong>"+u.betsdone.to_s+": </strong>&nbsp;&nbsp;&nbsp; "+u.fullName+"&nbsp;&nbsp; ( "+u.username+" )")
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
