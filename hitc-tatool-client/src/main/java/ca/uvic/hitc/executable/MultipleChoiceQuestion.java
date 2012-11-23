package ca.uvic.hitc.executable;

import java.awt.event.KeyEvent;
import java.util.List;

import ch.tatool.core.data.*;
import ch.tatool.core.display.swing.*;
import ch.tatool.core.display.swing.action.*;
import ch.tatool.core.display.swing.container.*;
import ch.tatool.core.display.swing.container.RegionsContainer.Region;
import ch.tatool.core.display.swing.panel.*;
import ch.tatool.core.executable.BlockingAWTExecutable;
import ch.tatool.data.*;

public class MultipleChoiceQuestion extends BlockingAWTExecutable 
		implements ActionPanelListener, DescriptivePropertyHolder {
	
	private HTMLPanel questionPanel;
	private KeyActionPanel actionPanel;
	
	private String questionText;
	private List<String> choices;
	private int correctAnswer;
	
	private Trial trial;
	private int response;
	
	public MultipleChoiceQuestion(String questionText, List<String> choices, int correctAnswer) {
		if (choices.size() > 9) {
			throw new IllegalArgumentException("Error: cannot support more than 9 choices.");
		}
		if (correctAnswer < 0 || correctAnswer >= choices.size()) {
			throw new IllegalArgumentException("Error: correct answer must be between 0 and "
					+ (choices.size() - 1) + " inclusive when there are " + choices.size()
					+ " choices.");
		}
		
		this.questionText = questionText;
		this.choices = choices;
		this.correctAnswer = correctAnswer;
		
		questionPanel = new HTMLPanel();
		actionPanel = new KeyActionPanel();
		actionPanel.addActionPanelListener(this);
	}

	@Override
	protected void startExecutionAWT() {
		SwingExecutionDisplay display = ExecutionDisplayUtils.getDisplay(this.getExecutionContext());
		ContainerUtils.showRegionsContainer(display);
		RegionsContainer container = ContainerUtils.getRegionsContainer();
		
		trial = this.getExecutionContext().getExecutionData().addTrial();
		trial.setParentId(this.getId());
		
		// Display the question and the available choices
		// TODO fix font size and text positioning!
		StringBuilder s = new StringBuilder("<center>");
		s.append("<p>" + questionText + "</p>");
		for (int i = 0; i < choices.size(); i++) {
			s.append("<p>" + (i + 1) + ") " + choices.get(i) + "</p>");
		}
		s.append("</center>");
		questionPanel.setHTMLString(s.toString(), ""); // passing null to the second parameter causes NPE
		container.setRegionContent(Region.CENTER, questionPanel);
		container.setRegionContentVisibility(Region.CENTER, true);
		
		CenteredTextPanel instructionPanel = new CenteredTextPanel();
		instructionPanel.setText("Type the number corresponding to your answer.");
		container.setRegionContent(Region.SOUTH, instructionPanel);
		container.setRegionContentVisibility(Region.SOUTH, true);
		
		actionPanel.addKey(KeyEvent.VK_1, null, 0);
		actionPanel.addKey(KeyEvent.VK_2, null, 1);
		actionPanel.addKey(KeyEvent.VK_3, null, 2);
		actionPanel.addKey(KeyEvent.VK_4, null, 3);
		actionPanel.addKey(KeyEvent.VK_5, null, 4);
		actionPanel.addKey(KeyEvent.VK_6, null, 5);
		actionPanel.addKey(KeyEvent.VK_7, null, 6);
		actionPanel.addKey(KeyEvent.VK_8, null, 7);
		actionPanel.addKey(KeyEvent.VK_9, null, 8);
		actionPanel.enableActionPanel();
	}

	public void actionTriggered(ActionPanel source, Object actionValue) {
		actionPanel.disableActionPanel();
		response = (Integer) actionValue;
		stop();
	}
	
	public Property<?>[] getPropertyObjects() {
		return new Property[] {
				Question.getQuestionProperty(),
				Question.getAnswerProperty(),
				Question.getResponseProperty(),
				Result.getResultProperty(),
				Points.getPointsProperty()
		};
	}

	public void stop() {
		RegionsContainer container = ContainerUtils.getRegionsContainer();
		container.setRegionContentVisibility(Region.CENTER, false);
		container.setRegionContentVisibility(Region.SOUTH, false);
		container.removeRegionContent(Region.CENTER);
		container.removeRegionContent(Region.SOUTH);
		
		// This stuff has to do with recording trial data
		Question.getQuestionProperty().setValue(this, questionText);
		Question.getAnswerProperty().setValue(this, choices.get(correctAnswer));
		Question.getResponseProperty().setValue(this, choices.get(response));
		boolean correct = response == correctAnswer;
		Points.setZeroOnePoints(this, correct);
		Result.getResultProperty().setValue(this, correct);
		DataUtils.storeProperties(trial, this);
		
		if (this.getFinishExecutionLock()) {
			this.finishExecution();
		}
	}
}
