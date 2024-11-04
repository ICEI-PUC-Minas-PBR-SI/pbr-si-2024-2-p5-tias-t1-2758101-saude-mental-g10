package saudemental.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "doubts")
public class Doubt {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String topic;
    private String description;
    private Date submissionDate;
    private String response;
    private Date responseDate;

    // Construtor padrão
    public Doubt() {
    }

    // Construtor com parâmetros
    public Doubt(String topic, String description, Date submissionDate, String response, Date responseDate) {
        this.topic = topic;
        this.description = description;
        this.submissionDate = submissionDate;
        this.response = response;
        this.responseDate = responseDate;
    }

    // Getters e Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getSubmissionDate() {
        return submissionDate;
    }

    public void setSubmissionDate(Date submissionDate) {
        this.submissionDate = submissionDate;
    }

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }

    public Date getResponseDate() {
        return responseDate;
    }

    public void setResponseDate(Date responseDate) {
        this.responseDate = responseDate;
    }
}
