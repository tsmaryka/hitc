/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * CreateAccountFrame.java
 *
 * Created on 10.08.2009, 20:19:29
 */
package ch.tatool.app.gui;

import java.awt.Dimension;
import java.awt.Image;
import java.util.Enumeration;
import java.util.HashMap;

import javax.swing.AbstractButton;
import javax.swing.ButtonGroup;
import javax.swing.JOptionPane;

import ch.tatool.app.Constants;
import ch.tatool.app.service.UserAccountService;
import ch.tatool.data.Messages;
import ch.tatool.data.UserAccount;

/**
 * UI for creating a new user account
 * 
 * @author Andre Locher
 */
public class CreateAccountFrame extends javax.swing.JFrame {

    private static final long serialVersionUID = 8458295653422189812L;
 
    /** UserAccountService - provides data for this frame. */
    private UserAccountService userAccountService;
    
    /** Reference to the LoginFrame. */
    private LoginFrame loginFrame;
    
    private Messages messages;
    
    public CreateAccountFrame() {
    }
    
    public void init() {
        initComponents();
    }

    public void setLoginFrame(LoginFrame loginFrame) {
    	this.loginFrame = loginFrame;
    }
    
    public void initialize() {
        pack();
        Dimension size = getSize();
        size.height += 20;
        setSize(size);
        setLocationRelativeTo(null);
        java.net.URL iconUrl = this.getClass().getResource("/ch/tatool/app/gui/icon.png"); //$NON-NLS-1$
		Image icon = getToolkit().getImage(iconUrl); 
		setIconImage(icon);
    }
    
    public void createAccount() {
        String userName = usernameText.getText();
        String birthYear = birthYearText.getText();
        String sex = null;
        if (getSelection(genderButtonGroup) != null) {
        	sex = getSelection(genderButtonGroup).getName();
        }
        if (userName.equals("") || userName == null) { //$NON-NLS-1$
            JOptionPane.showMessageDialog(this, messages.getString("CreateAccountFrame.errorMessage.userNameMissing"), //$NON-NLS-1$
                    messages.getString("General.errorMessage.windowTitle.warning"), JOptionPane.WARNING_MESSAGE); //$NON-NLS-1$
            return;
        }

        HashMap<String, String> accountProperties = new HashMap<String, String>();

        if (!birthYear.equals("") && birthYear != null) { //$NON-NLS-1$
            accountProperties.put(Constants.PROPERTY_ACCOUNT_BIRTH, birthYear);
        }
        if (sex != null) {
            accountProperties.put(Constants.PROPERTY_ACCOUNT_SEX, sex);
        }
        
        // set account language
        String language = (String) langComboBox.getSelectedItem();
        String lang = "en"; //$NON-NLS-1$
        if (language.equals("Deutsch")) { //$NON-NLS-1$
        	lang = "de"; //$NON-NLS-1$
        } else if (language.equals("English")) { //$NON-NLS-1$
        	lang = "en"; //$NON-NLS-1$
        }
        accountProperties.put(Constants.PROPERTY_ACCOUNT_LANG, lang);
        
        // add machine properties
        accountProperties.put(Constants.PROPERTY_MACHINE_OS_NAME, System.getProperty("os.name")); //$NON-NLS-1$
        accountProperties.put(Constants.PROPERTY_MACHINE_OS_ARCH, System.getProperty("os.arch")); //$NON-NLS-1$
        accountProperties.put(Constants.PROPERTY_MACHINE_OS_VERSION, System.getProperty("os.version")); //$NON-NLS-1$
        accountProperties.put(Constants.PROPERTY_MACHINE_USER_HOME, System.getProperty("user.home")); //$NON-NLS-1$

        UserAccount account = userAccountService.createAccount(userName,
                accountProperties, null);

        // if we got one, open it now
        if (account != null) {
            loginFrame.openAccount(account);
        } else {
        	JOptionPane.showMessageDialog(this, messages.getString("CreateAccountFrame.errorMessage.userNameExists"), //$NON-NLS-1$
        			messages.getString("General.errorMessage.windowTitle.warning"), JOptionPane.WARNING_MESSAGE); //$NON-NLS-1$
        }
    }

    public void cancelAccount() {
    	usernameText.setText(""); //$NON-NLS-1$
        birthYearText.setText(""); //$NON-NLS-1$
        genderButtonGroup.clearSelection();
        setVisible(false);
    }
    
    public static AbstractButton getSelection(ButtonGroup group) {
        for (Enumeration<AbstractButton> e = group.getElements(); e.hasMoreElements();) {
        	AbstractButton b = e.nextElement();
            if (b.getModel() == group.getSelection()) {
                return b;
            }
        }
        return null;
    }
    
    public void setMessages(Messages messages) {
    	this.messages = messages;
    }
    
    public Messages getMessages() {
    	return messages;
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {
        java.awt.GridBagConstraints gridBagConstraints;

        genderButtonGroup = new javax.swing.ButtonGroup();
        jPanel1 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        usernameText = new javax.swing.JTextField();
        createButton = new javax.swing.JButton();
        cancelButton = new javax.swing.JButton();
        jLabel4 = new javax.swing.JLabel();
        birthYearText = new javax.swing.JTextField();
        jLabel8 = new javax.swing.JLabel();
        maleRadioButton = new javax.swing.JRadioButton();
        femaleRadioButton = new javax.swing.JRadioButton();
        jLabel2 = new javax.swing.JLabel();
        langComboBox = new javax.swing.JComboBox();

        setTitle(messages.getString("General.title"));
        getContentPane().setLayout(new java.awt.GridBagLayout());

        jPanel1.setBorder(javax.swing.BorderFactory.createTitledBorder(null, messages.getString("CreateAccountFrame.labelTitle.newUser"), javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14))); // NOI18N

        jLabel1.setText(messages.getString("CreateAccountFrame.label.user"));

        createButton.setText(messages.getString("General.okLabel"));
        createButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                createButtonActionPerformed(evt);
            }
        });

        cancelButton.setText(messages.getString("General.cancelLabel"));
        cancelButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                cancelButtonActionPerformed(evt);
            }
        });

        jLabel4.setText(messages.getString("CreateAccountFrame.label.birthYear"));

        jLabel8.setText(messages.getString("CreateAccountFrame.label.sex"));

        genderButtonGroup.add(maleRadioButton);
        maleRadioButton.setText(messages.getString("CreateAccountFrame.label.sex.female"));
        maleRadioButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                maleRadioButtonActionPerformed(evt);
            }
        });

        genderButtonGroup.add(femaleRadioButton);
        femaleRadioButton.setText(messages.getString("CreateAccountFrame.label.sex.male"));
        femaleRadioButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                femaleRadioButtonActionPerformed(evt);
            }
        });

        jLabel2.setText(messages.getString("CreateAccountFrame.label.language"));

        langComboBox.setModel(new javax.swing.DefaultComboBoxModel(new String[] { messages.getString("CreateAccountFrame.label.language.German"), messages.getString("CreateAccountFrame.label.language.English") }));

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel4)
                    .addComponent(jLabel1)
                    .addComponent(jLabel2)
                    .addComponent(jLabel8))
                .addGap(18, 18, 18)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(createButton, javax.swing.GroupLayout.DEFAULT_SIZE, 86, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(cancelButton))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(maleRadioButton)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(femaleRadioButton))
                    .addComponent(usernameText, javax.swing.GroupLayout.DEFAULT_SIZE, 177, Short.MAX_VALUE)
                    .addComponent(birthYearText, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 177, Short.MAX_VALUE)
                    .addComponent(langComboBox, 0, 177, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(usernameText, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel4)
                    .addComponent(birthYearText, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(langComboBox, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel8)
                    .addComponent(maleRadioButton)
                    .addComponent(femaleRadioButton))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(createButton)
                    .addComponent(cancelButton))
                .addContainerGap(12, Short.MAX_VALUE))
        );

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.weightx = 1.0;
        gridBagConstraints.weighty = 1.0;
        gridBagConstraints.insets = new java.awt.Insets(11, 10, 11, 10);
        getContentPane().add(jPanel1, gridBagConstraints);

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void maleRadioButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_maleRadioButtonActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_maleRadioButtonActionPerformed

    private void femaleRadioButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_femaleRadioButtonActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_femaleRadioButtonActionPerformed

    private void cancelButtonActionPerformed(java.awt.event.ActionEvent evt) {// GEN-FIRST:event_cancelButtonActionPerformed
    	cancelAccount();
    }// GEN-LAST:event_cancelButtonActionPerformed

    private void createButtonActionPerformed(java.awt.event.ActionEvent evt) {// GEN-FIRST:event_createButtonActionPerformed
        createAccount();
    }// GEN-LAST:event_createButtonActionPerformed

    /**
     * @param args
     *            the command line arguments
     */
    public static void main(String args[]) {
        java.awt.EventQueue.invokeLater(new Runnable() {

            public void run() {
                new CreateAccountFrame().setVisible(true);
            }
        });
    }

    public void setUserAccountService(UserAccountService userAccountService) {
        this.userAccountService = userAccountService;
    }

    public UserAccountService getUserAccountService() {
        return userAccountService;
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTextField birthYearText;
    private javax.swing.JButton cancelButton;
    private javax.swing.JButton createButton;
    private javax.swing.JRadioButton femaleRadioButton;
    private javax.swing.ButtonGroup genderButtonGroup;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JComboBox langComboBox;
    private javax.swing.JRadioButton maleRadioButton;
    private javax.swing.JTextField usernameText;
    // End of variables declaration//GEN-END:variables
}
