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
package ch.tatool.core.display.swing.panel;

import javax.swing.Icon;

/**
 * Displays a simple text in the center of the screen.
 * 
 * @author Michael Ruflin
 */
public class TextAreaPanel extends javax.swing.JPanel {

	private static final long serialVersionUID = -775453298402854911L;

	/** Creates new form SimpleTextQuestionPanel */
	public TextAreaPanel() {
		initComponents();
	}

	public void setText(String text) {
		displayTextArea.setText(text);
	}

	public void setTextSize(int size) {
		displayTextArea.setFont(displayTextArea.getFont().deriveFont(
				displayTextArea.getFont().getStyle(), size));
	}

	/**
	 * This method is called from within the constructor to initialize the form.
	 * WARNING: Do NOT modify this code. The content of this method is always
	 * regenerated by the Form Editor.
	 */
	// @SuppressWarnings("unchecked")
	// <editor-fold defaultstate="collapsed"
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {
        java.awt.GridBagConstraints gridBagConstraints;

        jScrollPane1 = new javax.swing.JScrollPane();
        displayTextArea = new javax.swing.JTextArea();

        setOpaque(false);
        setLayout(new java.awt.GridBagLayout());

        jScrollPane1.setBackground(new java.awt.Color(255, 255, 255));
        jScrollPane1.setBorder(null);
        jScrollPane1.setOpaque(false);

        displayTextArea.setColumns(15);
        displayTextArea.setEditable(false);
        displayTextArea.setFont(new java.awt.Font("Arial", 0, 36)); // NOI18N
        displayTextArea.setLineWrap(true);
        displayTextArea.setRows(4);
        displayTextArea.setText("Nun folgt eine ganz simple Frage, die ich aber nat�rlich gerne in der Mitte ausgerichtet h�tte?");
        displayTextArea.setWrapStyleWord(true);
        displayTextArea.setBorder(null);
        displayTextArea.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        displayTextArea.setDisabledTextColor(new java.awt.Color(0, 0, 0));
        displayTextArea.setEnabled(false);
        jScrollPane1.setViewportView(displayTextArea);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.HORIZONTAL;
        gridBagConstraints.weightx = 0.1;
        gridBagConstraints.weighty = 0.1;
        gridBagConstraints.insets = new java.awt.Insets(0, 70, 0, 70);
        add(jScrollPane1, gridBagConstraints);
    }// </editor-fold>//GEN-END:initComponents

    // Variables declaration - do not modify//GEN-BEGIN:variables
    public javax.swing.JTextArea displayTextArea;
    private javax.swing.JScrollPane jScrollPane1;
    // End of variables declaration//GEN-END:variables

}
