class PaymentMailer < ActionMailer::Base

  def invoice(user, member, invoice, url, needs_account)
    @member = member
    @space = member.space
    @url = url
    @invoice = invoice
    @needs_account = needs_account

    mail(to: @member.email, 
         from: user.email,
         subject: "New invoice from #{@space.name}"
         )
  end

  def payment(user, member, payment, url, needs_account)
    @member = member
    @space = member.space
    @url = url
    @payment = payment
    @needs_account = needs_account

    mail(to: @member.email, 
         from: user.email,
         subject: "Payment to #{@space.name}"
         )
  end

end
