/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package generatepatches;

/**
 *
 * @author Zach
 */
public class GeneratePatches {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        int size = 20;
        int centerRange = 5;
        int[][] patch = new int[size][size];
        
        int centerRow = getRandom(size,centerRange);
        int centerCol = getRandom(size,centerRange);
        
        patch[centerRow][centerCol] = 8;
        double num;
        for(int pass = 1; pass < 6; pass++){
            int[][] oldPatch = copyPatch(patch);
            for(int i = 1; i < size-1; i++){
                for(int j = 1; j < size-1; j++){
                    num = Math.random();
                    if(isCandidate(oldPatch,i,j) && (num < (0.6-0.05*pass))){
                        patch[i][j] = 8;
                    }
                }
            }
        }
        
        boolean minFound; int minI=0, maxI=0;
        //fill in gaps in columns
        for(int col = 0; col < patch.length; col++){
            minFound = false; minI = 0; maxI = 0;
            for(int i = 0; i < patch.length; i++){
                if(patch[i][col] > 0){
                    if(!minFound){
                        minFound = true;
                        minI = i;
                    }
                    maxI = i;
                }
            }
            
            if(minFound){
                for(int j = minI; j <= maxI; j++){
                    patch[j][col] = 8;
                }
            }
        }
        //fill in gaps in rows
        for(int row = 0; row < patch.length; row++){
            minFound = false; minI = 0; maxI = 0;
            for(int i = 0; i < patch.length; i++){
                if(patch[row][i] > 0){
                    if(!minFound){
                        minFound = true;
                        minI = i;
                    }
                    maxI = i;
                }
            }
            
            if(minFound){
                for(int j = minI; j <= maxI; j++){
                    patch[row][j] = 8;
                }
            }
        }
        
        
        displayPatch(patch);
    }
    
    public static int getRandom(int size, int centerRange){
        return (int)Math.floor(centerRange*Math.random()) + (size-centerRange)/2;
    }
    
    public static int[][] copyPatch(int[][] patch){
        int[][] newPatch = new int[patch.length][patch[0].length];
        for(int i = 0; i < patch.length; i++){
            System.arraycopy(patch[i], 0, newPatch[i], 0, patch[0].length);
        }
        return newPatch;
    }
    
    public static boolean isCandidate(int[][] patch, int row, int col){
        if(patch[row][col] > 0){
            return false;
        }
        
        for(int i = row-1; i <= row+1; i++){
            for(int j = col-1; j <= col+1; j++){
                if(patch[i][j] > 0)
                    return true;
            }
        }
        return false;
    }
    
    public static void displayPatch(int[][] patch){
        for(int j = 0; j < patch.length; j++){
            for(int i = 0; i < patch.length; i++){
                if(patch[j][i] <= 0){
                    System.out.print("o ");
                }else{
                    System.out.print("x ");
                }
            }
            System.out.println();
        }
    }
}
