
import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    var body: some View{

        NavigationView{
            VStack{
                if self.status{
                    HomeScreen()
                }else{
                    ZStack{
                      NavigationLink(
                        destination: SignUp(show: self.$show),
                        isActive: self.$show){
                        Text("")
                      }
                      .hidden()
                        
                        Login(show: self.$show)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear{
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}

struct HomeScreen: View{
    var body: some View{
        VStack{
            Text("Logged in successfully")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black.opacity(0.7))
            
            Button(action: {
                
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }){
                Text("Log out")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.top, 25)
        }
    }
}

struct Login: View {

    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var password = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View{
        ZStack{
        ZStack(alignment: .topTrailing){
            
            GeometryReader{_ in
            
                VStack{
                    Image("logo2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Text("Login to your account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                        .padding(.top,5)
                    
                    TextField("Email",text: self.$email)
                        .autocapitalization(.none)
                        .padding(.all,10)
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("color") : self.color, lineWidth: 2))
                        .padding(.top, 15)

                    //password field
                    HStack(spacing: 15 ){
                        VStack{
                            if self.visible{
                                TextField("Password",text: self.$password)
                                    .autocapitalization(.none)

                            
                            }
                            else{
                                SecureField("Password", text: self.$password)
                                    .autocapitalization(.none)

                            }
                        }
                    
                    
                        Button(action: {
                            self.visible.toggle()
                        }){
                            Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(self.color)
                        }
                        
                    }
                    .padding(.all,10)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color("color") : self.color, lineWidth: 2))
                    .padding(.top, 4)
                    
                    //forgot password
                    HStack{
                        Spacer()
                        Button(action: {
                            self.reset()
                        }){
                            Text("Forget password")
                                .fontWeight(.bold)
                                .foregroundColor(Color.red)
                        }
                    }
                    .padding(.top, 20)
                    
                    
                    Button(action: {
                        self.verify()
                    }){
                        Text("Log in")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.top, 25)
                    
                }
                .padding(.horizontal,20)
                
            }
            
            Button (action: {
                self.show.toggle()
            }){
                Text("Register")
                    .foregroundColor(.red)
                    .fontWeight(.bold)
            }
            .padding()

        }
        }
        
        if self.alert{
            ErrorView(alert: self.$alert, error: self.$error)
        }
    }
    func verify(){
        if self.email != "" && self.password != ""{
            
            Auth.auth().signIn(withEmail: self.email, password: self.password){(res,err) in
                if err != nil{
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                print("Success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
            
        }else{
            self.error = "Please fill all the details"
            self.alert.toggle()
        }
    }
    
    func reset(){
        if self.email != ""{
            Auth.auth().sendPasswordReset(withEmail: self.email) {
                (err) in
                if err != nil{
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                self.error = "RESET"
                self.alert.toggle()
            }
        }
        else{
            self.error = "Email id is empty"
            self.alert.toggle()
        }
    }
}

struct SignUp: View {

    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var password = ""
    @State var repassword = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View{
        
        ZStack{
            ZStack(alignment: .topLeading){
                
                GeometryReader{_ in
                
                    VStack{
                        Image("logo2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                        Text("Login to your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top,5)
                        
                        TextField("Email",text: self.$email)
                            .autocapitalization(.none)
                            .padding(.all,10)
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("color") : self.color, lineWidth: 2))
                            .padding(.top, 15)

                        //password field
                        HStack(spacing: 15 ){
                            VStack{
                                if self.visible{
                                    TextField("Password",text: self.$password)
                                        .autocapitalization(.none)

                                }
                                else{
                                    SecureField("Password", text: self.$password)
                                        .autocapitalization(.none)
                                }
                            }
                        
                        
                            Button(action: {
                                self.visible.toggle()
                            }){
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding(.all,10)
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color("color") : self.color, lineWidth: 2))
                        .padding(.top, 4)
                        
                        HStack(spacing: 15 ){
                            VStack{
                                if self.revisible{
                                    TextField("Re-Enter",text: self.$repassword)
                                        .autocapitalization(.none)

                                
                                }
                                else{
                                    SecureField("Re-Enter", text: self.$repassword)
                                        .autocapitalization(.none)

                                }
                            }
                        
                        
                            Button(action: {
                                self.revisible.toggle()
                            }){
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding(.all,10)
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.repassword != "" ? Color("color") : self.color, lineWidth: 2))
                        .padding(.top, 4)
                        
                        
                        
                        Button(action: {
                            self.register()
                        }){
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                    }
                    .padding(.horizontal,20)
                    
                }
                Button (action: {
                    self.show.toggle()
                }){
                    Image(systemName: "chevron.left")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        
                }
                .padding()
            }
            
            if self.alert{
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    func register(){
        if self.email != ""{
            
            if self.password == self.repassword{
                Auth.auth().createUser(withEmail: self.email, password: self.password){
                    (res, err) in
                    if err != nil {
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    print("Success")
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            }else{
                self.error = "Password did not match"
                self.alert.toggle()
            }
        }else{
            self.error = "email cannot be empty"
            self.alert.toggle()
        }
    }
}

struct ErrorView: View{
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    var body: some View{
        GeometryReader{_ in
//            Spacer()
            VStack(alignment: .center){
//                Spacer()
                HStack{
                    Text(self.error == "RESET" ? "MESSAGE" : "Error")
                        .font(.title)
                        .foregroundColor(self.color)
                        .fontWeight(.bold)
                    Spacer()
                }
//                .padding([.top, .leading, .trailing], 51.0)
                
                Text(self.error == "RESET" ? "Password reset link has been sent successfully" : self.error)
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button(action:{
                    self.alert.toggle()
                }){
                    Text(self.error == "RESET" ? "OK" : "Cancel")
                    .foregroundColor(.blue)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
            
            }
            .padding(.vertical, 25)
//            .frame(height: 250, alignment: .center)
//            .frame(width: CGFloat(30), height: CGFloat(40), alignment: .center)
            .frame(width: UIScreen.main.bounds.width - 3, alignment: .center)
            .background(Color.white)
            .cornerRadius(15)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}
