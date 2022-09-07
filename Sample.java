import java.util.Scanner;
class Sample
{
    public static void main(String args[])
    {
        int n ; 
        System.out.println("enter size of arrays");
        Scanner s = new Scanner(System.in);
        n = s.nextInt();
        char a[] = new char[n];

        for(int i=0;i<n;i++)
        {
            System.out.print("enter a char ");
            a[i] = s.next().charAt(0);
        }

        for(int i=(n-1);i>0;i--)
        {
            System.out.print(""+a[i]);
        }
    }
}