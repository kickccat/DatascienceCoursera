## "best" function takes two arguments: state and outcome, reads the outcome-of-care-measures.csv file and
## returns a character vector with the name of the hospital that has the best (i.e. lowest) 30-day mortality
## for the specified outcome in that state.

## The hospital name is the name provided in the Hospital.Name variable. The outcomes can
## be one of “heart attack”, “heart failure”, or “pneumonia”.
## Hospitals that do not have data on a particular outcome should be excluded from the set of hospitals
## when deciding the rankings

best <- function(state, outcome) {
    ## Read outcome data
    dataFrame <- read.csv("outcome-of-care-measures.csv", header = TRUE)
    states <- unique(dataFrame$State)
    outcomes <- c("heart attack", "heart failure", "pneumonia")
    
    ## Check that state and outcome are valid
    try(if(!(state %in% states)) stop(message("invalid state!")))
    try(if(!(outcome %in% outcomes)) stop(message("invalid outcome!")))
    
    ## Columns names to store the death rate
    storeColNames <- c(names(dataFrame)[11], names(dataFrame)[17], names(dataFrame)[23])
    
    ## Column name to compare the death rate
    compColName <- storeColNames[match(outcome, outcomes)]
    
    ## Find the compared column with the state respectively
    dataFrame.state <- dataFrame[dataFrame$State==state, ]
    compCol <- as.numeric(dataFrame.state[, compColName])
    
    ## Find the hospital with the minimum death rate respectively
    foundMin <- which(compCol==min(compCol, na.rm = TRUE))
    foundHospitals <- dataFrame.state[foundMin, 2]
    
    ## If more than one hospital found, return the first hospital name alphabetical sorted
    hospital <- as.character(sort(foundHospitals))
    ## print(attributes(hospital))
    hospital[1]
}
