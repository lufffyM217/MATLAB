%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%----------------------   -----------------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function encrypt = encrypt()

global edit1 edit2 edit3 pass1 pass2 data_encrypt
global irt endrt ert iprt pt

%%%%%%%%%%%%%%%%%%%%%%%%%%%-------------------------------%%%%%%%%%%%%%%%%%%%%%%%%%%%


data = get(edit1,'String');           
data = double(uint8(data))';           
data_length = length(data);            
adds = 8-mod(data_length,8);           
if adds ~= 0
    for i = 1:adds
        data(data_length+i) = 0;       
    end
    data_length = data_length+adds;
end

%%%%%%%%%%%%-------%%%%%%%%%%%%
key = get(pass1,'String');             
keylength = length(key);              
keytemp0 = uint8(key);                 
keys = [149 57 208 147 21 183 27];    

%%%%%%%%%%--- ---%%%%%%%%%%
if keylength < 7                     
   for i = keylength+1:7
       keytemp0(i) = keys(i);
   end
end
for i=1:7                             
      keyusetemp(i) = keytemp0(i);
end
keyuse = char(keyusetemp);            

%%%%%%%%%%--- ---%%%%%%%%%%%
pwb = str2bin(keyuse,7,2);            
pwb = rebit(pwb,iprt);                 
ki = gerkey(pwb);                    

%%%%%%%%%%%---  ---%%%%%%%%%%%%
times = data_length/8;               
for i = 0:times-1
    for j = 1:8
        tempdata(j) = data(8*i+j);     
    end
    encrydata = char(tempdata);
    encrydata = des(encrydata,ki);    
    for k = 0:7
        temp = encrydata(k*8+1:(k+1)*8);
        data_encrypt(i*8+k+1,1) = bin2dec(temp);
    end
end

%%%%%%%%%%%---  ---%%%%%%%%%%%%
data_show =dec2bin(data_encrypt)';
set(edit2,'string',data_show)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%---------------------%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%----------- -%%%%%%%%%%%%%%%%%%%%
function bin = str2bin(str,k,flag)



l = length(str);
bin = [];
temp = [];

for x = 1:l
     temp = [temp,dec2bin(str(x),8)]; 
end

if flag ~= 0                           
     n = ceil(l*8/k);                  
     rb = mod(l*8,k);
     sb = 0;
     if rb ~= 0
     sb = k-rb;                      
     for i = 1:sb
         z(i) = '0';
     end
     temp = [temp z];
     end     
     for x = 0:n-1
        temp1 = temp(x*k+1:(x+1)*k);
        lone = length(find(temp1 == '1')); 
        if flag == 1                   
            if mod(lone,2) == 0
                opb = '1';
            else
                opb = '0';
            end
        else if flag == 2              
                if mod(lone,2) == 0
                    opb = '0';
                else
                    opb = '1';
                end
            end
        end
       temp1 = [temp1 opb];           
       bin = [bin temp1];
    end
else
        bin = temp;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%----------------------%%%%%%%%%%%%%%%%%%%%%
function so = rebit(si,k)


lk=length(k);
for i=1:lk
    so(i)=si(k(i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%---------------%%%%%%%%%%%%%%%%%%%%
function ki=gerkey(k)



mt = ...                              
    [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16;
     1 1 2 2 2 2 2 2 1  2  2  2  2  2  2  1];
rt = ...                              
    [14 17 11 24  1  5  3 28 ...
     15  6 21 10 23 19 12  4 ...
     26  8 16  7 27 20 13  2 ...
     41 52 31 37 47 55 30 40 ...
     51 45 33 48 44 49 39 56 ...
     34 53 46 42 50 36 29 32];
kl = k(1:28);                          
kr = k(29:56);
for i = mt(1,1):mt(1,16)               
    kl = mr(kl,mt(2,i));               
    kr = mr(kr,mt(2,i));               
    k = [kl kr];                      
    for j = 1:48                       
        ki(i,j) = k(fix(rt(j)));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%----------------------%%%%%%%%%%%%%%%%%%%%
function nk = mr(k,n)



l = length(k);
k1 = k(n+1:l);
k2 = k(1:n);
nk = [k1 k2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%-----------------------%%%%%%%%%%%%%%%%%%%%%
function ef = des(pf,ki)



global irt endrt ert iprt pt
pfb = str2bin(pf,0,0);                
pfb = rebit(pfb,irt);                
lpfb = pfb(1:32);                      
rpfb = pfb(33:64);                     

for i = 0:15
    templ = lpfb;
    lpfb = rpfb;                       
    tempr = rebit(rpfb,ert);           
    rpfb = char(xor(ki(i+1,:)-48,tempr-48)+48); 
    rpfb = sbox(rpfb);                 
    rpfb = rebit(rpfb,pt);             
    rpfb = char(xor(templ-48,rpfb-48)+48); 
end
pfb = [rpfb lpfb];
pfb = rebit(pfb,endrt);               
ef = pfb;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%--------------------%%%%%%%%%%%%%%%%%%%%%
function so = sbox(si)


sbox1 = ...                            % S1��
       [14  4 13 1  2 15 11  8  3 10  6 12  5  9 0  7;
         0 15  7 4 14  2 13  1 10  6 12 11  9  5 3  8;
         4  1 14 8 13  6  2 11 15 12  9  7  3 10 5  0;
        15 12  8 2  4  9  1  7  5 11  3 14 10  0 6 13];
sbox2 = ...                            % S2��
       [15  1  8 14  6 11  3  4  9 7  2 13 12 0  5 10;
         3 13  4  7 15  2  8 14 12 0  1 10  6 9 11  5;
         0 14  7 11 10  4 13  1  5 8 12  6  9 3  2 15;
        13  8 10  1  3 15  4  2 11 6  7 12  0 5 14  9];
sbox3 = ...                            % S3��
       [10  0  9 14 6  3 15  5  1 13 12  7 11  4  2  8;
        13  7  0  9 3  4  6 10  2  8  5 14 12 11  5  1;
        13  6  4  9 8 15  3  0 11  1  2 12  5 10 14  7;
         1 10 13  0 6  9  8  7  4 15 14  3 11  5  2 12];
sbox4 = ...                            % S4��
       [ 7 13 14 3  0  6  9 10  1 2 8  5 11 12  4 15;
        13  8 11 5  6  5  0  3  4 7 2 12  1 10 14  9;
        10  6  9 0 12 11  7 13 15 1 3 14  5  2  8  4;
         3 15  0 6 10  1 13  8  9 4 5 11 12  7  2 14];
sbox5 = ...                            % S5��
       [ 2 12  4  1  7 10 11  6  8  5  3 15 13 0 14  9;
        14 11  2 12  4  7 13  1  5  0 15 10  3 9  8  6;
         4  2  1 11 10 13  7  8 15  9 12  5  6 3  0 14;
         1  8 12  7  1 14  2 13  6 15  0  9 10 4  5  3];
sbox6 = ...                            % S6��
       [12  1 10 15 9  2  6  8  0 13  3  4 14  7  5 11;
        10 15  4  2 7 12  9  5  6  1 13 14  0 11  3  8;
         9 14 15  5 2  8 12  3  7  0  4 10  1 13 11  6;
         4  3  2 12 9  5 15 10 11 14  1  7  6  0  8 13];
sbox7 = ...                            % S7��
       [ 4 11  2 14 15 0  8 13  3 12 9  7  5 10 6  1;
        13  0 11  7  4 9  1 10 14  3 5 12  2 15 8  6;
         1  4 11 13 12 3  7 14 10 15 6  8  0  5 9  2;
         6 11 13  8  1 4 10  7  9  5 0 15 14  2 3 12];
sbox8 = ...                            % S8��
       [13  2  8 4  6 15 11  1 10  9  3 14  5  0 12  7;
         1 15 13 8 10  3  7  4 12  5  6 11  0 14  9  2;
         7 11  4 1  9 12 14  2  0  6 10 13 15  3  5  8;
         2  1 14 7  4 10  8 13 15 12  9  0  3  5  6 11];
sbox = [sbox1 sbox2 sbox3 sbox4 sbox5 sbox6 sbox7 sbox8];
sboxout = [ ];
for i = 0:7
    sboxin(i+1,1:6) = si(i*6+1:(i+1)*6); 
    rind = bin2dec([sboxin(i+1,1),sboxin(i+1,6)])+1; 
    nind = bin2dec(sboxin(i+1,2:5))+1+i*16; 
    sboxout = [sboxout dec2bin(sbox(rind,nind),4)];
end
so = sboxout;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%