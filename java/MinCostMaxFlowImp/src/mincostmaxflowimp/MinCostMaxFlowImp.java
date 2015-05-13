/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package mincostmaxflowimp;

/**
 *
 * @author Zach
 */
public class MinCostMaxFlowImp {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        System.out.println("Hello World");
        
        int[][] capacity = {{0,2,2,0},{2,0,0,2},{2,0,0,2},{0,2,2,0}};
        int[][] cost = {{0,1,1,0},{1,0,0,1},{1,0,0,1},{0,1,1,0}};
        int source = 0; int sink = 3;
        MinCostMaxFlow nf = new MinCostMaxFlow();
        int[] maxflow = nf.getMaxFlow(capacity,cost,source,sink);
        
        for(int j = 0; j < maxflow.length; j++){
            System.out.println(maxflow[j]);
        }
    }
    
}
