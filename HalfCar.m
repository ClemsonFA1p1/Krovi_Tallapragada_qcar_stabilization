function dXdt = HalfCar(t,X,b)

% x = [x,dx,z,dz,th,dth]
x = X(1);
dx = X(2);
z = X(3);
dz = X(4);
th = X(5);
dth = X(6);

z1 = z - b.L1*th;
z2 = z + b.L2*th;

dz1 = dz - b.L1*dth;
dz2 = dz + b.L2*dth;

x1 = x - b.L1*cos(th);
x2 = x + b.L2*cos(th);

dzr1 = b.dzrx(x1)*dx;
dzr2 = b.dzrx(x2)*dx;

ddz = 1/b.m*(-b.k1*(z1 - b.zr(x1)) - b.c1*(dz1 - dzr1) - b.k2*(z2 - b.zr(x2)) - b.c2*(dz2 - dzr2));
ddth = 1/b.I*(b.k1*(z1-b.zr(x1))*b.L1 + b.c1*(dz1 - dzr1) - b.k2*(z2 - b.zr(x2))*b.L2 - b.c2*(dz2 - dzr2)*b.L2);
ddx = 1/b.tau*(b.ux-dx);

dXdt = [dx; 
        ddx;
        dz; 
        ddz; 
        dth;
        ddth];
    
%fprintf('mu = %4.1f \t t = %4.2f\t x = %4.2f \t z = %4.2f \t zr = %4.2f \t dzdt = %4.2f\n',b.mu, t, x, z, b.zr(x),dXdt(4)) 

end
