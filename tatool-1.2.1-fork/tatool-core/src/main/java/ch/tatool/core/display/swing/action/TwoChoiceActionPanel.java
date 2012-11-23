/*******************************************************************************
 * Copyright (c) 2011 Michael Ruflin, Andr� Locher, Claudia von Bastian.
 * 
 * This file is part of Tatool.
 * 
 * Tatool is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published 
 * by the Free Software Foundation, either version 3 of the License, or 
 * (at your option) any later version.
 * 
 * Tatool is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with Tatool. If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
package ch.tatool.core.display.swing.action;

import java.awt.KeyEventDispatcher;
import java.awt.KeyboardFocusManager;
import java.awt.event.KeyEvent;

/**
 * Provides two buttons to choose from - left and right.
 * The buttons are also linked to the keyboard, where the left half of the character keys
 * trigger the left action, the other half the right action.
 * 
 * Arrow keys trigger as follows: left and down trigger the left action, right and up the right action.
 *
 * @author Michael Ruflin
 */
public class TwoChoiceActionPanel extends AbstractActionPanel {

    private static final long serialVersionUID = 650511256207592037L;
    
    private SelectChoiceKeyEventDispatcher keyEventDispatcher;
    
    private Object leftChoiceActionValue, rightChoiceActionValue;
    
    /** Creates new form TwoChoiceActionPanel */
    public TwoChoiceActionPanel() {
        initComponents();
        keyEventDispatcher = new SelectChoiceKeyEventDispatcher();
    }

	/** Get the label of the left button. */
	public void setLeftChoice(String label, Object actionValue) {
		leftChoiceButton.setText(label);
		leftChoiceActionValue = actionValue;
	}
	
	public void setLeftChoice(String labelAndActionValue) {
		setLeftChoice(labelAndActionValue, labelAndActionValue);
	}

	/** Get the label of the right button. */
	public void setRightChoice(String label, Object actionValue) {
		rightChoiceButton.setText(label);
		rightChoiceActionValue = actionValue;
	}

	public void setRightChoice(String labelAndActionValue) {
		setRightChoice(labelAndActionValue, labelAndActionValue);
	}
	
	/** Call this method when starting the task. */
	public void enableActionPanel() {
		super.enableActionPanel();
		
	    // register the key dispatcher
        KeyboardFocusManager.getCurrentKeyboardFocusManager().addKeyEventDispatcher(keyEventDispatcher);
	}
	
	/** Call this method when stopping the task. */
	public void disableActionPanel() {
		super.disableActionPanel();
		
        // unregister the key dispatcher
        KeyboardFocusManager.getCurrentKeyboardFocusManager().removeKeyEventDispatcher(keyEventDispatcher);
	}

	/**
	 * KeyListener that links some of the keyboard keys to the left and right choice buttons.
	 */
	class SelectChoiceKeyEventDispatcher implements KeyEventDispatcher {
	    /** Called when a key has been typed. */
	    public boolean dispatchKeyEvent(KeyEvent e) {
	        if (e.getID() == KeyEvent.KEY_PRESSED) {
                switch (e.getKeyCode()) {
                
                // left button keys
                case KeyEvent.VK_A:
                    // this should give a visual feedback of the click
                    leftChoiceButton.doClick();
                    break;
                
                // right button keys
                case KeyEvent.VK_L:
                    rightChoiceButton.doClick();
                    break;
                    
                }
	        }
	        
	        // never consume the event...
	        return false;
        }
	}
	
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    //@SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        leftChoiceButton = new javax.swing.JButton();
        rightChoiceButton = new javax.swing.JButton();

        setMinimumSize(new java.awt.Dimension(156, 60));
        setPreferredSize(new java.awt.Dimension(112, 60));
        setLayout(new java.awt.GridLayout(1, 2, 10, 10));

        leftChoiceButton.setFont(leftChoiceButton.getFont().deriveFont(leftChoiceButton.getFont().getSize()+20f));
        leftChoiceButton.setText("A");
        leftChoiceButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                leftChoiceButtonActionPerformed(evt);
            }
        });
        add(leftChoiceButton);

        rightChoiceButton.setFont(rightChoiceButton.getFont().deriveFont(rightChoiceButton.getFont().getSize()+20f));
        rightChoiceButton.setText("B");
        rightChoiceButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                rightChoiceButtonActionPerformed(evt);
            }
        });
        add(rightChoiceButton);
    }// </editor-fold>//GEN-END:initComponents

	private void leftChoiceButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_leftChoiceButtonActionPerformed
		fireActionTriggered(leftChoiceActionValue);
	}//GEN-LAST:event_leftChoiceButtonActionPerformed

	private void rightChoiceButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_rightChoiceButtonActionPerformed
		fireActionTriggered(rightChoiceActionValue);
	}//GEN-LAST:event_rightChoiceButtonActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton leftChoiceButton;
    private javax.swing.JButton rightChoiceButton;
    // End of variables declaration//GEN-END:variables

}