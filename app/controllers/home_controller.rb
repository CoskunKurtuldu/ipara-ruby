class HomeController < ApplicationController
  def index
    if request.post?
      @@settings.BaseUrl="https://www.ipara.com/3dgate"
      req = Threedpaymentrequest.new 
      req.OrderId = SecureRandom.uuid
      req.Echo = "Echo"
      req.Mode = @@settings.Mode
      req.Version = @@settings.Version
      req.Amount = "10000" # 100 tL
      req.CardOwnerName =params[:nameSurname]
      req.CardNumber = params[:cardNumber]
      req.CardExpireMonth = params[:month]
      req.CardExpireYear = params[:year]
      req.Installment = params[:installment]
      req.Cvc = params[:cvc]
      req.ThreeD = "true"
      req.UserId=""
      req.CardId=""
      req.PurchaserName = "Murat"
      req.PurchaserSurname = "Kaya"
      req.PurchaserEmail = "murat@kaya.com"
      req.SuccessUrl = "http://localhost:3000/home/threeDResultSuccess"
      req.FailUrl = "http://localhost:3000/home/threeDResultFail"
      @returnData= req.execute(req,@@settings)
      render inline: @returnData

    else
      end
  end

  def threeDResultSuccess
    if request.post?
       paymentresponse = Threedinitresponse.new
      paymentresponse.OrderId =params[:orderId]
      paymentresponse.Result =params[:result]
      paymentresponse.Amount =params[:amount]
      paymentresponse.Mode =params[:mode]
      if (params[:errorCode] != nil)
          paymentresponse.ErrorCode =params[:errorCode]
      end
      if (params[:errorMessage] != nil)
          paymentresponse.ErrorMessage =params[:errorMessage]
      end
      if (params[:transactionDate] != nil)
          paymentresponse.TransactionDate =params[:transactionDate]
      end
      if (params[:hash] != nil)
          paymentresponse.Hash =params[:hash]
          end
      if Core::Helper::Validate3DReturn(paymentresponse,@@settings)
    #ApiPaymentResponse çağrılacak
    req=Threedpaymentcompleterequest.new
    
    req.OrderId = params[:orderId]
    req.Echo = "Echo"
    req.Mode =  @@settings.Mode
    req.Amount = "10000" # 100 tL
    req.CardOwnerName ="Fatih Coşkun"
    req.CardNumber = "4282209027132016"
    req.CardExpireMonth = "05"
    req.CardExpireYear = "18"
    req.Installment = "1"
    req.Cvc = "000"
    req.ThreeD = "true"
    req.ThreeDSecureCode=params[:threeDSecureCode].force_encoding("UTF-8")
    req.ThreeDSecureCode=req.ThreeDSecureCode
    req.UserId=""
    req.CardId=""

    
    #region Sipariş veren bilgileri
    req.Purchaser = Purchaser.new 
    req.Purchaser.Name = "Murat"
    req.Purchaser.SurName = "Kaya"
    req.Purchaser.BirthDate = "1986-07-11"
    req.Purchaser.Email = "murat@kaya.com"
    req.Purchaser.GsmPhone = "5881231212"
    req.Purchaser.IdentityNumber = "1234567890"
    req.Purchaser.ClientIp = "127.0.0.1"
    #endregion

    #region Fatura bilgileri

    req.Purchaser.Invoiceaddress = Purchaseraddress.new 
    req.Purchaser.Invoiceaddress.Name = "Murat"
    req.Purchaser.Invoiceaddress.SurName = "Kaya"
    req.Purchaser.Invoiceaddress.Address = "Mevlüt Pehlivan Mah. Multinet Plaza Şişli"
    req.Purchaser.Invoiceaddress.ZipCode = "34782"
    req.Purchaser.Invoiceaddress.CityCode = "34"
    req.Purchaser.Invoiceaddress.IdentityNumber = "1234567890"
    req.Purchaser.Invoiceaddress.CountryCode = "TR"
    req.Purchaser.Invoiceaddress.TaxNumber = "123456"
    req.Purchaser.Invoiceaddress.TaxOffice = "Kozyatağı"
    req.Purchaser.Invoiceaddress.CompanyName = "iPara"
    req.Purchaser.Invoiceaddress.PhoneNumber = "2122222222"
    #endregion

    #region Kargo Adresi bilgileri
    req.Purchaser.Shippingaddress = Purchaseraddress.new 
    req.Purchaser.Shippingaddress.Name = "Murat"
    req.Purchaser.Shippingaddress.SurName = "Kaya"
    req.Purchaser.Shippingaddress.Address = "Mevlüt Pehlivan Mah. Multinet Plaza Şişli"
    req.Purchaser.Shippingaddress.ZipCode = "34782"
    req.Purchaser.Shippingaddress.CityCode = "34"
    req.Purchaser.Shippingaddress.IdentityNumber = "1234567890"
    req.Purchaser.Shippingaddress.CountryCode = "TR"
    req.Purchaser.Shippingaddress.PhoneNumber = "2122222222"
    #endregion

    #region Ürün bilgileri
    req.Products = Array.new()
    p =Product.new 
    p.Title = "Telefon"
    p.Code = "TLF0001"
    p.Price = "5000"
    p.Quantity = 1
    req.Products << p

    p =Product.new 
    p.Title = "Bilgisayar"
    p.Code = "BLG0001"
    p.Price = "5000"
    p.Quantity = 1
    req.Products << p

    #endregion
     @@settings.BaseUrl= "https://api.ipara.com/"
      @returnData= req.execute(req,@@settings)
      end
  else
  end 
  end

  def threeDResultFail
    @returnData= params
  end

  def bininqury
    
    if request.post?
      req=Binnumberrequest.new
      req.binNumber =  params[:binNumber]
      @returnData= req.execute(req,@@settings)

    else
    end
  end

  
  def addCardToWallet
    if request.post?
      req=Bankcardcreaterequest.new
      req.userId = params[:userId]
      req.cardOwnerName = params[:nameSurname]
      req.cardNumber = params[:cardNumber]
      req.cardAlias = params[:cardAlias]
      req.cardExpireMonth = params[:month]
      req.cardExpireYear = params[:year]
      req.clientIp = "127.0.0.1"
      @returnData= req.execute(req,@@settings)

    else
    end
  end
  def getCardFromWallet
    if request.post?
      req=Bankcardinquiryrequest.new
      req.userId = params[:userId]
      req.cardId = params[:cardId]
       req.clientIp = "127.0.0.1"
      @returnData= req.execute(req,@@settings)

    else
    end
  end
  def deleteCardFromWallet
    if request.post?
      req=Bankcarddeleterequest.new
      req.userId = params[:userId]
      req.cardId = params[:cardId]
       req.clientIp = "127.0.0.1"
      @returnData= req.execute(req,@@settings)

    else
    end
  end
  def paymentinqury
       
    if request.post?
      req=Paymentinquiryrequest.new
      req.orderId =  params[:orderId]
      @returnData= req.execute(req,@@settings)

    else
    end
  end
  def apiPayment
    if request.post?
    req=Apipaymentrequest.new
    
    req.OrderId = SecureRandom.uuid
    req.Echo = "Echo"
    req.Mode =  @@settings.Mode
    req.Amount = "10000" # 100 tL
    req.CardOwnerName =params[:nameSurname]
    req.CardNumber = params[:cardNumber]
    req.CardExpireMonth = params[:month]
    req.CardExpireYear = params[:year]
    req.Installment = params[:installment]
    req.Cvc = params[:cvc]
    req.ThreeD = "false"
    req.UserId=""
    req.CardId=""

    
    #region Sipariş veren bilgileri
    req.Purchaser = Purchaser.new 
    req.Purchaser.Name = "Murat"
    req.Purchaser.SurName = "Kaya"
    req.Purchaser.BirthDate = "1986-07-11"
    req.Purchaser.Email = "murat@kaya.com"
    req.Purchaser.GsmPhone = "5881231212"
    req.Purchaser.IdentityNumber = "1234567890"
    req.Purchaser.ClientIp = "127.0.0.1"
    #endregion

    #region Fatura bilgileri

    req.Purchaser.Invoiceaddress = Purchaseraddress.new 
    req.Purchaser.Invoiceaddress.Name = "Murat"
    req.Purchaser.Invoiceaddress.SurName = "Kaya"
    req.Purchaser.Invoiceaddress.Address = "Mevlüt Pehlivan Mah. Multinet Plaza Şişli"
    req.Purchaser.Invoiceaddress.ZipCode = "34782"
    req.Purchaser.Invoiceaddress.CityCode = "34"
    req.Purchaser.Invoiceaddress.IdentityNumber = "1234567890"
    req.Purchaser.Invoiceaddress.CountryCode = "TR"
    req.Purchaser.Invoiceaddress.TaxNumber = "123456"
    req.Purchaser.Invoiceaddress.TaxOffice = "Kozyatağı"
    req.Purchaser.Invoiceaddress.CompanyName = "iPara"
    req.Purchaser.Invoiceaddress.PhoneNumber = "2122222222"
    #endregion

    #region Kargo Adresi bilgileri
    req.Purchaser.Shippingaddress = Purchaseraddress.new 
    req.Purchaser.Shippingaddress.Name = "Murat"
    req.Purchaser.Shippingaddress.SurName = "Kaya"
    req.Purchaser.Shippingaddress.Address = "Mevlüt Pehlivan Mah. Multinet Plaza Şişli"
    req.Purchaser.Shippingaddress.ZipCode = "34782"
    req.Purchaser.Shippingaddress.CityCode = "34"
    req.Purchaser.Shippingaddress.IdentityNumber = "1234567890"
    req.Purchaser.Shippingaddress.CountryCode = "TR"
    req.Purchaser.Shippingaddress.PhoneNumber = "2122222222"
    #endregion

    #region Ürün bilgileri
    req.Products = Array.new()
    p =Product.new 
    p.Title = "Telefon"
    p.Code = "TLF0001"
    p.Price = "5000"
    p.Quantity = 1
    req.Products << p

    p =Product.new 
    p.Title = "Bilgisayar"
    p.Code = "BLG0001"
    p.Price = "5000"
    p.Quantity = 1
    req.Products << p

    #endregion

      @returnData= req.execute(req,@@settings)

    else
    end
  end
  def apiPaymentWithWallet
    if request.post?
      req=Apipaymentrequest.new
    
    req.OrderId = SecureRandom.uuid
    req.Echo = "Echo"
    req.Mode =  @@settings.Mode
    req.Amount = "10000" # 100 tL
    req.CardOwnerName =""
    req.CardNumber =""
    req.CardExpireMonth = ""
    req.CardExpireYear = ""
    req.Installment = ""
    req.Cvc = ""
    req.ThreeD = "false"
    req.UserId=params[:userId]
    req.CardId=params[:cardId]

    
    #region Sipariş veren bilgileri
    req.Purchaser = Purchaser.new 
    req.Purchaser.Name = "Murat"
    req.Purchaser.SurName = "Kaya"
    req.Purchaser.BirthDate = "1986-07-11"
    req.Purchaser.Email = "murat@kaya.com"
    req.Purchaser.GsmPhone = "5881231212"
    req.Purchaser.IdentityNumber = "1234567890"
    req.Purchaser.ClientIp = "127.0.0.1"
    #endregion

    #region Fatura bilgileri

    req.Purchaser.Invoiceaddress = Purchaseraddress.new 
    req.Purchaser.Invoiceaddress.Name = "Murat"
    req.Purchaser.Invoiceaddress.SurName = "Kaya"
    req.Purchaser.Invoiceaddress.Address = "Mevlüt Pehlivan Mah. Multinet Plaza Şişli"
    req.Purchaser.Invoiceaddress.ZipCode = "34782"
    req.Purchaser.Invoiceaddress.CityCode = "34"
    req.Purchaser.Invoiceaddress.IdentityNumber = "1234567890"
    req.Purchaser.Invoiceaddress.CountryCode = "TR"
    req.Purchaser.Invoiceaddress.TaxNumber = "123456"
    req.Purchaser.Invoiceaddress.TaxOffice = "Kozyatağı"
    req.Purchaser.Invoiceaddress.CompanyName = "iPara"
    req.Purchaser.Invoiceaddress.PhoneNumber = "2122222222"
    #endregion

    #region Kargo Adresi bilgileri
    req.Purchaser.Shippingaddress = Purchaseraddress.new 
    req.Purchaser.Shippingaddress.Name = "Murat"
    req.Purchaser.Shippingaddress.SurName = "Kaya"
    req.Purchaser.Shippingaddress.Address = "Mevlüt Pehlivan Mah. Multinet Plaza Şişli"
    req.Purchaser.Shippingaddress.ZipCode = "34782"
    req.Purchaser.Shippingaddress.CityCode = "34"
    req.Purchaser.Shippingaddress.IdentityNumber = "1234567890"
    req.Purchaser.Shippingaddress.CountryCode = "TR"
    req.Purchaser.Shippingaddress.PhoneNumber = "2122222222"
    #endregion

    #region Ürün bilgileri
    req.Products = Array.new()
    p =Product.new 
    p.Title = "Telefon"
    p.Code = "TLF0001"
    p.Price = "5000"
    p.Quantity = 1
    req.Products << p

    p =Product.new 
    p.Title = "Bilgisayar"
    p.Code = "BLG0001"
    p.Price = "5000"
    p.Quantity = 1
    req.Products << p

    #endregion

      @returnData= req.execute(req,@@settings)

    else
    end
  end



end
