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

import java.awt.Dimension;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.KeyEventDispatcher;
import java.awt.KeyboardFocusManager;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;

import javax.swing.GroupLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.SwingConstants;
import javax.swing.GroupLayout.Alignment;
import javax.swing.LayoutStyle.ComponentPlacement;

/**
 * Panel that provides a submit button and an optional description label.
 * The default submitted actionValue is null, but can be changed through a setter.
 *
 * @author Michael Ruflin
 */
public class SubmitActionPanel extends AbstractActionPanel {

	private static final long serialVersionUID = -6768844783262584074L;

	/** Is this action panel enabled. */
	private boolean enabled;
	
	/** ActionValue provided upon submission. */
	private Object actionValue;
	
	/** KeyEventDispatcher */
	private SubmitKeyEventDispatcher keyEventDispatcher; 
	
	/** Creates new form SubmitActionPanel */
    public SubmitActionPanel() {
        initComponents();
        
        keyEventDispatcher = new SubmitKeyEventDispatcher();
        
        // default actionValue
        actionValue = null;
    }

    /** Get the label of the left button. */
    public void setButtonText(String label) {
        if (label != null) {
	submitButton.setText(label);
        }
    }

    public Object getActionValue() {
		return actionValue;
	}

	public void setActionValue(Object actionValue) {
		this.actionValue = actionValue;
	}
	
	public void enableActionPanel() {
	    enabled = true;
            submitButton.setEnabled(true);

        // register the key dispatcher
        KeyboardFocusManager.getCurrentKeyboardFocusManager().addKeyEventDispatcher(keyEventDispatcher);
	}
	
	public void disableActionPanel() {
	    enabled = false;
	    submitButton.setEnabled(false);
        // register the key dispatcher
        KeyboardFocusManager.getCurrentKeyboardFocusManager().removeKeyEventDispatcher(keyEventDispatcher);
	}

	/** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {
        GridBagConstraints gridBagConstraints;

        submitButton = new JButton();

        setLayout(new GridBagLayout());

        submitButton.setFont(submitButton.getFont().deriveFont(submitButton.getFont().getSize()+25f));
        submitButton.setText("Next");
        submitButton.setMargin(new Insets(8, 20, 8, 20));
        submitButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                submitButtonActionPerformed(evt);
            }
        });
        add(submitButton, new GridBagConstraints());
    }// </editor-fold>//GEN-END:initComponents

    private void submitButtonActionPerformed(ActionEvent evt) {//GEN-FIRST:event_submitButtonActionPerformed
        if (enabled) {
            fireActionTriggered(actionValue);
        }
    }//GEN-LAST:event_submitButtonActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    JButton submitButton;
    // End of variables declaration//GEN-END:variables

    
    /**
     * KeyListener that links some of the keyboard keys to the left and right choice buttons.
     */
    class SubmitKeyEventDispatcher implements KeyEventDispatcher {
        /** Called when a key has been typed. */
        public boolean dispatchKeyEvent(KeyEvent e) {
            if (e.getID() == KeyEvent.KEY_PRESSED) {
                switch (e.getKeyCode()) {
                // Enter and space
                case KeyEvent.VK_ENTER:
                case KeyEvent.VK_SPACE:
                    submitButton.doClick();
                    break;
                }
            }
            
            // never consume the event...
            return false;
        }
    }
}