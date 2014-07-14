class MyFooter < ActiveAdmin::Component
  def build
    super(id: "footer")
		render :partial => "/layouts/footer"
  end
end