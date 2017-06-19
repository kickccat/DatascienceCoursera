rankall <- function(outcome, num = "best"){
    ## Read csv data
    dataFrame <- read.csv("outcome-of-care-measures.csv", header = TRUE)
    outcomes <- c("heart attack", "heart failure", "pneumonia")
    states <- unique(dataFrame$State)
    
    ## Check that outcome and rank value are valid
    if(!(outcome %in% outcomes)) stop("invalid outcome!")
    if(is.character(num)) {
        if(!num %in% c("best", "worst")) {
            stop("invalid rank!")
        }
    }
    
    ## Set the new dataframe stored with the ranking values
    ## Choose hospital name, state, heart attack, heart failure and pneumonia from original dataframe
    newDataFrame <- dataFrame[, c(2, 7, 11, 17, 23)] 
    idxCol <- c(3, 4, 5)  ## index of all ranking columns in the new dataframe
    
    idxChosen <- idxCol[match(outcome, outcomes)]  ## index of the chosen ranking column
    
    ## The hospitals with the chosen outcome with
    ## columns "1. hospital name", "2. ranking value" and "3. state"
    hospitals <- newDataFrame[, c(1, idxChosen, 2)]
    hospitals <- hospitals[hospitals[, 2]!="Not Available", ]
    
    ## Change factors to numeric values
    hospitals[, 2] <- suppressWarnings(as.numeric(as.character(hospitals[, 2])))
    
    ## hospitals <- hospitals[order(hospitals[, 3]), ]
    
    ## Order the ranking
    hospitals <- hospitals[order(hospitals[, 2], hospitals[, 1], hospitals[, 3]), ]
    
    ## Set the blank result dataframe
    result <- data.frame()
    worstResult <- data.frame()
    
    ## Reorder the ranking according to the different states and storing in result
    for (state in states){
        tempSub <- subset(hospitals, hospitals[, 3]==state) ## slicing as per state
        tempSub <- tempSub[order(tempSub[, 2], tempSub[, 1]), ] ## reorder as per ranking score
        worstResult <- rbind(worstResult, tempSub[nrow(tempSub), ])
        rankIndex <- c(1:nrow(tempSub)) ## set the ranking index
        newSub <- cbind(tempSub, rankIndex) ## add the ranking index as a new column to the slicing dataframe
        result <- rbind(result, newSub)
    }
    
    ## Reorder as per ranking index and hospital name
    result <- result[order(result$rankIndex, result$State, result$Hospital.Name), ]
    worstResult <- worstResult[order(worstResult$State, worstResult$Hospital.Name), ]
    
    ## Check the num value
    if(num == "best"){
        num <- 1
    }
    else if(num == "worst"){
        slicedResult <- worstResult
        return(slicedResult[, c(1, 3)])
    }
    else if(!is.na(num) & num <= nrow(hospitals)){
        num <- as.numeric(num)
    }
    else if(num > nrow(hospitals)){
        return(NA)
    }
    
    ## Slice the result as the given num and outcome
    slicedResult <- subset(result, result[, 4]==num)
    
    ## Return the desired result
    return(slicedResult[, c(1, 3)])
}
