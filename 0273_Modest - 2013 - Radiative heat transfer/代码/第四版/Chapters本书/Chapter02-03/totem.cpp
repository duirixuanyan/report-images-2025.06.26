// Program Totem

// Program to evaluate the total, directional-or-hemispherical emittance of an opaque material
// INPUT (by changing values in FUNCTION emlcl(y) below:
//	N-1		= number of data points for spectral, directional-or-hemispherical emittance
//	nrefr	= refractive index of adjoining material (=1 for vacuum and gases)
//	T		= temperature of opaque material if total emittance is desired, in K, or
//			  temperature of gray radiating source if total absorptance is desired
//	eps(N)	= N values of data points for spectral, directional-or-hemispherical emittance
//	lambda(N)= corresponding N values of wavelengths, in micrometer
// OUTPUT
//	emiss	= total emittance or absorptance
// NOTE: 
// FUNCTION emlcl(y) uses linear interpolation to evaluate spectral emittances between data points


# include <iostream.h>
# include <math.h>

double emlcl(double);

int main ()
{
int i;
double emiss;

// Gaussian quadrature weights
const double w[6]={0.0, .2955242247, .2692667193, .2190863625, .1494513491, .0666713443};

// Original Gaussian quadrature values x(i) given for completeness; the y_i=n*lambda*T are the values
// corresponding to f(n*lambda*T)=x=.5*(1+-x_i)
// note that the first element of the array is 0.0 to correspond with fortran subscripting
const double x[6]={0.0, .1488743389, .4333953941, .6794095682, .8650633666, .9739065285};
const double y[11]={ 0.0, 1503.32158713938, 2004.78303570275, 2495.09250579963, 3044.62899329486, 
	3709.12502109211, 4567.40650306271, 5762.97273448694, 7613.99482631694, 11045.6325211325, 20764.7554806188};

emiss=0.e0;

   for (i=1;i<=5;i=i+1)
      emiss=emiss+w[6-i]*emlcl(y[i])+w[i]*emlcl(y[i+5]);
     
   emiss=.5e0*emiss;
   cout<<"Total emittance = "<<emiss<<endl;
   
return 0;
}

double emlcl(double y)
{
   const int N=3;
   int i;
   double emlcl,wl,nrefr=2.,T=500.;
// Material of Problem 3.1,  N=3
   const double lambda[N]={0.0, 4.9, 5.};
   const double eps[N]={0.0, .5, .3};
// Aluminum oxide, Fig. 1-13,  N=9
//   const double lambda[N]={0.0, 1., 2., 3., 4., 5., 6., 7., 8.};
//   const double eps[N]={.12, .13, .15, .20, .33, .65, .88, .98};
   wl=y/(nrefr*T);
   if(wl<lambda[1]) 
        emlcl=eps[1];
   else if(wl>lambda[N-1])
        emlcl=eps[N-1];
   else
        for (i=2;i<=N-1;i=i+1)
		{
        	if (wl<=lambda[i]) 
        		{emlcl=(eps[i-1]*(lambda[i]-wl)+eps[i-1]*(wl-lambda[i-1]))/(lambda[i]-lambda[i-1]); 
			i=N;} 
        	}
   
   return emlcl;
}

