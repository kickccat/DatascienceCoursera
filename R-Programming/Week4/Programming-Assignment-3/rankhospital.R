rankhospital <- function(state, outcome, num = "best") {
    ## Read outcome data
    dataFrame <- read.csv("outcome-of-care-measures.csv", header = TRUE)
    states <- unique(dataFrame$State)
    outcomes <- c("heart attack", "heart failure", "pneumonia")
    
    ## Check that state, outcome and rank value are valid
    if(!(state %in% states)) stop("invalid state!")
    if(!(outcome %in% outcomes)) stop("invalid outcome!")
    if(is.character(num)) {
        if(!num %in% c("best", "worst")) {
            stop("invalid rank!")
        }
    }
    
    ## Set the new dataframe stored with the ranking values
    ## Choose hospital name, state, heart attack, heart failure and pneumonia
    newDataFrame <- dataFrame[, c(2, 7, 11, 17, 23)] 
    idxCol <- c(3, 4, 5)  ## index of all ranking columns in the new dataframe
    
    idxChosen <- idxCol[match(outcome, outcomes)]  ## index of the chosen ranking column
    
    ## The hospitals with the chosen state and illness
    hospitals <- newDataFrame[newDataFrame$State==state, c(1, idxChosen)]
    hospitals <- hospitals[hospitals[, 2]!="Not Available", ]
    
    ## Change factors to numeric values
    hospitals[, 2] <- suppressWarnings(as.numeric(as.character(hospitals[, 2])))
    
    ## Order the ranking
    hospitals <- hospitals[order(hospitals[, 2], hospitals[,1]), ]
    
    ## Check the num value
    if(num == "best"){
        num <- 1
    }
    else if(num == "worst"){
        num <- nrow(hospitals)
    }
    else if(!is.na(num) & num <= nrow(hospitals)){
        num <- as.numeric(num)
    }
    else if(num > nrow(hospitals)){
        return(NA)
    }
    
    ## Return the selected hospital name
    return(as.character(hospitals[, 1][num]))
}
