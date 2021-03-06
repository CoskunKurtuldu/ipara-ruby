module Core
class Helper
    TransactionDate = "transactionDate";
    Version = "version";
    Token = "token";
    Accept = "Accept";
   Application_xml = "application/xml";
   Application_json = "application/json";

    def self.GetTransactionDateString()  
         return DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
    end

    def self.Sha1Creator(key)
    p Digest::SHA1.hexdigest(key)

    end


    def self.CreateToken(publicKey, hashString)
        return publicKey+ ":" +Digest::SHA1.base64digest(hashString)
     end

     def self.ComputeHash(hashString)
        return Digest::SHA1.base64digest(hashString)
     end
  
     def self.GetHttpHeaders(settings, acceptType)
        # header = {:accept =>acceptType, :'' => acceptType}
         header={}
        header[:'accept'] = acceptType
        header[:'content-type'] = acceptType
        header[:'Token'] = Core::Helper::CreateToken(settings.PublicKey,settings.HashString)
        p Core::Helper::CreateToken(settings.PublicKey,settings.HashString)
        header[:'Version'] = settings.Version
        header[:'transactionDate'] = settings.transactionDate         
        return header
    end

    def self.Validate3DReturn(paymentResponse,settings)
    
        if paymentResponse.Hash ==nil
            
            throw :Exception,
            'Ödeme cevabı hash bilgisi boş. '
        end
         hashText = paymentResponse.OrderId + paymentResponse.Result + paymentResponse.Amount + paymentResponse.Mode + paymentResponse.ErrorCode +
        paymentResponse.ErrorMessage + paymentResponse.TransactionDate + settings.PublicKey + settings.PrivateKey
         hashedText = Core::Helper::ComputeHash(hashText)
        if (hashedText != paymentResponse.Hash)
            throw :Exception,
            'Ödeme cevabı hash doğrulaması hatalı. '
        end
        return true
    

    end
end 

class HttpClient
    def self.get(url, header={})
        RestClient.get(url, header)
      end
  
      def self.post(url, header, content)
        RestClient.post(url, content, header)
      end
 end

end