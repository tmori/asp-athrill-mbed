#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Digital Craft Inc.
#
#  �嵭����Ԥϡ��ʲ���(1)��(4)�ξ������������˸¤ꡤ�ܥ��եȥ���
#  �����ܥ��եȥ���������Ѥ�����Τ�ޤࡥ�ʲ�Ʊ���ˤ���ѡ�ʣ������
#  �ѡ������ۡʰʲ������ѤȸƤ֡ˤ��뤳�Ȥ�̵���ǵ������롥
#  (1) �ܥ��եȥ������򥽡��������ɤη������Ѥ�����ˤϡ��嵭������
#      ��ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ��꤬�����Τޤޤη��ǥ���
#      ����������˴ޤޤ�Ƥ��뤳�ȡ�
#  (2) �ܥ��եȥ������򡤥饤�֥������ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ�����Ǻ����ۤ�����ˤϡ������ۤ�ȼ���ɥ�����ȡ�����
#      �ԥޥ˥奢��ʤɡˤˡ��嵭�����ɽ�����������Ѿ�浪��Ӳ���
#      ��̵�ݾڵ����Ǻܤ��뤳�ȡ�
#  (3) �ܥ��եȥ������򡤵�����Ȥ߹���ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ��ʤ����Ǻ����ۤ�����ˤϡ����Τ����줫�ξ�����������
#      �ȡ�
#    (a) �����ۤ�ȼ���ɥ�����ȡ����Ѽԥޥ˥奢��ʤɡˤˡ��嵭����
#        �ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ����Ǻܤ��뤳�ȡ�
#    (b) �����ۤη��֤��̤�������ˡ�ˤ�äơ�TOPPERS�ץ������Ȥ�
#        ��𤹤뤳�ȡ�
#  (4) �ܥ��եȥ����������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������뤤���ʤ�»
#      ������⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ����դ��뤳�ȡ�
#      �ޤ����ܥ��եȥ������Υ桼���ޤ��ϥ���ɥ桼������Τ����ʤ���
#      ͳ�˴�Ť����ᤫ��⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ�
#      ���դ��뤳�ȡ�
#
#  �ܥ��եȥ������ϡ�̵�ݾڤ��󶡤���Ƥ����ΤǤ��롥�嵭����Ԥ�
#  ���TOPPERS�ץ������Ȥϡ��ܥ��եȥ������˴ؤ��ơ�����λ�����Ū
#  ���Ф���Ŭ������ޤ�ơ������ʤ��ݾڤ�Ԥ�ʤ����ޤ����ܥ��եȥ���
#  �������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������������ʤ�»���˴ؤ��Ƥ⡤��
#  ����Ǥ�����ʤ���
#
#  $Id: Condition.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "ttj/bin/class/TTJModule.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Condition
  # ��    ��: pre_condition, post_condition�ξ����������륯�饹
  #===================================================================
  class Condition
    include TTJModule

    #=================================================================
    # ������: pre_condition�ޤ���post_condition�γƥ��֥������Ȥξ����
    #         ���ܸ첽�����塤���ƤΥ��֥������Ȥξ����Ĥʤ����֤�
    #=================================================================
    def japanize_condition_info(sAllCond, sIndent, sCondition)
      check_class(String, sAllCond)    # pre_condition��post_condition�Υ�٥�
      check_class(String, sIndent)     # pre_condition��post_condition�δ��ܥ���ǥ��
      check_class(String, sCondition)  # pre_condition��post_condition�ξ���

      @hExistState  = {}       # nil°�����������State
      @sBlankIndent = sIndent  # °����Ĺ����׻�����ݤ˻Ȥ�����ǥ��
      bChangeFlag   = false    # ���֤��Ѳ��Τʤ�condition�򼨤�

      # ���֥�������ID��ǽ��Ϥ��뤿��������֥������ȤΥ����פ򥽡��Ȥ����ݻ�
      aAllObject = hAllObject.keys()
      aAllObject = aAllObject.sort()

      # ���֥������Ƚ硤����˥��֥�������ID������ܸ첽������»ܤ���
      GRP_TTJ_OBJECT.each{|hObject|
        aAllObject.each{|sObjectID|
          if (hObject.keys[0] == hAllObject[sObjectID].sObjectType)
            sObjectType = hAllObject[sObjectID].sObjectType  # ���֥������ȤΥ�����
            sObjectID   = hAllObject[sObjectID].sObjectID    # �ƥ���ID

            # �ͤ�nil�Ǥʤ�°�����Ф�
            @hExistState = hAllObject[sObjectID].hState.reject{|key, val|
              hAllObject[sObjectID].aNilAttributes.include?(key)
            }

            # �Ѳ��Τʤ�post_condition�����ܸ첽���������������
            next if ((sCondition == TSR_LBL_POST) && (@hExistState.empty?() == true))

            # ���ܸ첽��������
            bChangeFlag = true
            sAllCond += japanize_condition(sObjectType, sObjectID)
          end
        }
      }

      # ���֤��Ѳ��Τʤ�condition�ξ��
      if (bChangeFlag == false)
        sAllCond += "#{sIndent}#{TTJ_POST_EMPTY}#{TTJ_NEW_LINE}#{TTJ_NEW_LINE}"
      end

      # ���ꤵ��Ƥ��ʤ����֥������ȤΥ��顼����
      aObjectErr= []

      GRP_TTJ_OBJECT.each{|hTTJObject|
        aObjectErr.push(hTTJObject.keys[0])  # ���֥������ȤΥ����פ��������
      }

      aAllObject.each{|sObjectID|
        # TESTY�����ɤ�TTJ���֥������ȥޥ������Ӥ��ƹ��ʤ����ϥ��顼��å�������ȿ�Ǥ���
        if (aObjectErr.include?(hAllObject[sObjectID].sObjectType) == false)
          $sAttrErr += "[#{sCondition}/#{sObjectID.gsub("#{@sTestID}_", "")} : #{hAllObject[sObjectID].sObjectType}] #{@sTestID}#{TTJ_NEW_LINE}"  # ���ꤵ��Ƥ��ʤ����֥������ȤΥ��顼����
        end
      }

      return sAllCond  # [String]pre_condition�ޤ���post_condition�����ܸ첽����ʸ����
    end

    #=================================================================
    # ������: �ƥ��֥������Ȥξ�������ܸ첽�����֤�
    #=================================================================
    def japanize_condition(sObjectType, sObjectID)
      check_class(String, sObjectType)  # ���֥������ȤΥ�����
      check_class(String, sObjectID)    # ���֥������Ȥ�ID

      # ID��type�ɲ�
      @hExistState.store(TTJ_STT_ID,   sObjectID)
      @hExistState.store(TSR_PRM_TYPE, sObjectType)

      # Blank����
      @nBlankSize = 1
      @hExistState.each_key{|key|
        if (key == TSR_PRM_STATE)
          blank_size(GRP_TTJ_STATUS[key][sObjectType])
        else
          blank_size($hTTJAttribute[key])
        end
      }

      sReturnState = ""

      # °����ˤ������ܸ첽�����򳫻Ϥ���
      GRP_TTJ_ATTRIBUTE.each{|hAttribute|
        @hExistState.each{|key, val|
          if (hAttribute.keys[0] == key)
            case key
            when TTJ_STT_ID
              val = val.gsub("#{@sTestID}_", "")     # Alias���
              sReturnState += "#{blank(hAttribute[key])}#{val}"  # ���֥������Ȥ�ID����

            when TSR_PRM_TYPE
              GRP_TTJ_OBJECT.each{|hObject|  # dictionary�Υ��֥������Ƚ���Ѵ�
                if (hObject.keys[0] == val)
                  sReturnState += "#{blank(hAttribute[key])}#{hObject.values[0]}"  # ���֥������Ȥ�ID����
                end
              }

            # �ƥ��֥������Ȥ�state
            when TSR_PRM_STATE
              sReturnState += "#{blank(GRP_TTJ_STATUS[key][sObjectType])}#{GRP_TTJ_STATUS[val]}"

            # �ƥ��֥������Ȥ�°��
            when TSR_PRM_ATR
              sAtr = ""

              if (val.include?(KER_TA_NULL))
                sAtr += "#{GRP_TTJ_STATUS[TSR_PRM_ATR][KER_TA_NULL]}"
              else
                if (val.include?(KER_TA_TPRI))
                  sAtr += "#{GRP_TTJ_STATUS[TSR_PRM_ATR][KER_TA_TPRI]}#{TTJ_PAUSE}"
                end

                if (val.include?(KER_TA_WMUL))
                  sAtr += "#{GRP_TTJ_STATUS[TSR_PRM_ATR][KER_TA_WMUL]}#{TTJ_PAUSE}"
                end

                if (val.include?(KER_TA_CLR))
                  sAtr += "#{GRP_TTJ_STATUS[TSR_PRM_ATR][KER_TA_CLR]}#{TTJ_PAUSE}"
                end

                if (val.include?(KER_TA_MPRI))
                  sAtr += "#{GRP_TTJ_STATUS[TSR_PRM_ATR][KER_TA_MPRI]}#{TTJ_PAUSE}"
                end

                if (val.include?(KER_TA_STA))
                  sAtr += "#{GRP_TTJ_STATUS[TSR_PRM_ATR][KER_TA_STA]}#{TTJ_PAUSE}"
                end

                if (val.include?(KER_TA_ENAINT))
                  sAtr += "#{GRP_TTJ_STATUS[TSR_PRM_ATR][KER_TA_ENAINT]}#{TTJ_PAUSE}"
                end

                if (val.include?(KER_TA_DISINT))
                  sAtr += "#{GRP_TTJ_STATUS[TSR_PRM_ATR][KER_TA_DISINT]}#{TTJ_PAUSE}"
                end
              end

              sAtr = sAtr.gsub(/, \z/, "")
              sReturnState += "#{blank(hAttribute[key])}#{sAtr}"

            # �Ԥ��װ�
            when TSR_PRM_WOBJID
              if (GRP_TTJ_STATUS[val].nil?() == true)
                val = val.gsub("#{@sTestID}_", "")  # Alias���
                sReturnState += "#{blank(hAttribute[key])}#{val}"
              else
                sReturnState += "#{blank(hAttribute[key])}#{GRP_TTJ_STATUS[val]}"
              end

            # cpu��å����ǥ����ѥå�
            when TSR_PRM_LOCCPU, TSR_PRM_DISDSP
              sReturnState += "#{blank(hAttribute[key])}#{GRP_TTJ_STATUS[val][key]}"

            # �����ͥ���٥ޥ���
            when TSR_PRM_CHGIPM
              if (GRP_TTJ_STATUS[key][val].nil?() == true)
                sReturnState += "#{blank(hAttribute[key])}#{val}"
              else
                sReturnState += "#{blank(hAttribute[key])}#{GRP_TTJ_STATUS[key][val]}"
              end

            # �����Ԥ��������ꥹ��
            when TSR_PRM_STSKLIST
              if (val.empty?() == false)
                sSendTaskList = ""

                val.each{|hVal|
                  sSendTaskList += "#{TTJ_BLOCK_OPEN}#{hVal.keys[0]}#{TTJ_PAUSE}#{hVal[hVal.keys[0]][TSR_VAR_DATA]}#{TTJ_BLOCK_CLOSE}#{TTJ_PAUSE}"
                }

                sSendTaskList = sSendTaskList.gsub(/, \z/, "")
                sSendTaskList = sSendTaskList.gsub("#{@sTestID}_", "")  # Alias���
                sReturnState += "#{blank(hAttribute[key])}#{sSendTaskList}"
              else
                sReturnState += "#{blank(hAttribute[key])}#{TTJ_ATTR_EMPTY}"
              end

            # �����Ԥ��������ꥹ��
            when TSR_PRM_RTSKLIST
              if (val.empty?() == false)
                sRcvTaskList = ""

                val.each{|hVal|
                  sRcvTaskList += "#{TTJ_BLOCK_OPEN}#{hVal.keys[0]}"

                  if ((hVal[hVal.keys[0]].nil?() == false) && (sObjectType == TSR_OBJ_DATAQUEUE))  # �ǡ������塼�ξ��
                    sRcvTaskList += "#{TTJ_PAUSE}#{hVal[hVal.keys[0]][TSR_VAR_VAR]}"
                  elsif ((hVal[hVal.keys[0]].nil?() == false) && (sObjectType == TSR_OBJ_P_DATAQUEUE))  # ͥ���٥ǡ������塼�ξ��
                    sRcvTaskList += "#{TTJ_PAUSE}#{hVal[hVal.keys[0]][TSR_VAR_VARPRI]}#{TTJ_PAUSE}#{hVal[hVal.keys[0]][TSR_VAR_VARDATA]}"
                  end

                  sRcvTaskList += "#{TTJ_BLOCK_CLOSE}#{TTJ_PAUSE}"
                }

                sRcvTaskList = sRcvTaskList.gsub(/, \z/, "")
                sRcvTaskList = sRcvTaskList.gsub("#{@sTestID}_", "")  # Alias���
                sReturnState += "#{blank(hAttribute[key])}#{sRcvTaskList}"
              else
                sReturnState += "#{blank(hAttribute[key])}#{TTJ_ATTR_EMPTY}"
              end

            # �ǡ��������ΰ�Υǡ����ꥹ��
            when TSR_PRM_DATALIST
              if (val.empty?() == false)
                sDataList = "#{TTJ_BLOCK_OPEN}"

                val.each{|hVal|
                  sDataList += "#{hVal[TSR_VAR_DATA]}"#{TTJ_PAUSE}"
                }

                sDataList += "#{TTJ_BLOCK_CLOSE}"
                sDataList = sDataList.gsub(/, \}/, TTJ_BLOCK_CLOSE)
                sReturnState += "#{blank(hAttribute[key])}#{sDataList}"
              else
                sReturnState += "#{blank(hAttribute[key])}#{TTJ_ATTR_EMPTY}"
              end

            # �Ԥ��������ꥹ��
            when TSR_PRM_WTSKLIST
              if (val.empty?() == false)
                sWaitTaskList = ""

                val.each{|hVal|
                  sWaitTaskList += "#{TTJ_BLOCK_OPEN}"

                  if (sObjectType == TSR_OBJ_SEMAPHORE)  # ���ޥե��ξ��
                    sWaitTaskList += "#{hVal.keys[0]}"
                  elsif (sObjectType == TSR_OBJ_EVENTFLAG)  # ���٥�ȥե饰�ξ��
                    hVal.each{|wtlKey, wtlVal|
                      sWaitTaskList += "#{wtlKey}"
                      sWaitTaskList += "#{TTJ_PAUSE}#{wtlVal[TSR_VAR_WAIPTN]}"
                      sWaitTaskList += "#{TTJ_PAUSE}#{wtlVal[TSR_VAR_WFMODE]}"

                      if (wtlVal[TSR_VAR_VAR].nil?() == false)
                        sWaitTaskList += "#{TTJ_PAUSE}#{wtlVal[TSR_VAR_VAR]}"
                      end
                    }
                  elsif (sObjectType == TSR_OBJ_MAILBOX) ||  # �᡼��ܥå����ξ��
                        (sObjectType == TSR_OBJ_MEMORYPOOL)  #����Ĺ����ס���ξ��
                    hVal.each{|wtlKey, wtlVal|
                      sWaitTaskList += "#{wtlKey}"

                      if (wtlVal.nil?() == false)
                        sWaitTaskList += "#{TTJ_PAUSE}#{wtlVal[TSR_VAR_VAR]}"
                      end
                    }
                  end

                  sWaitTaskList += "#{TTJ_BLOCK_CLOSE}#{TTJ_PAUSE}"
                }

                sWaitTaskList = sWaitTaskList.gsub(/, \z/, "")
                sWaitTaskList = sWaitTaskList.gsub("#{@sTestID}_", "")  # Alias���
                sReturnState += "#{blank(hAttribute[key])}#{sWaitTaskList}"
              else
                sReturnState += "#{blank(hAttribute[key])}#{TTJ_ATTR_EMPTY}"
              end

            # ��å������ꥹ��
            when TSR_PRM_MSGLIST
              if (val.empty?() == false)
                sMsgList = ""

                val.each{|hVal|
                  sMsgList += "#{TTJ_BLOCK_OPEN}#{hVal[TSR_VAR_MSG]}"

                  if (hVal[TSR_VAR_MSGPRI].nil?() == false)
                    sMsgList += "#{TTJ_PAUSE}#{hVal[TSR_VAR_MSGPRI]}"
                  end

                  sMsgList += "#{TTJ_BLOCK_CLOSE}#{TTJ_PAUSE}"
                }

                sMsgList = sMsgList.gsub(/, \z/, "")
                sMsgList = sMsgList.gsub("#{@sTestID}_", "")  # Alias���
                sReturnState += "#{blank(hAttribute[key])}#{sMsgList}"
              else
                sReturnState += "#{blank(hAttribute[key])}#{TTJ_ATTR_EMPTY}"
              end

            # �ѿ�
            when TSR_PRM_VAR
              sVar = ""

              # �ѿ��β��Ԥˤ�륤��ǥ�ȷ׻�
              sVarBlank     = blank(hAttribute[key])
              nVarTabCount  = sVarBlank.count("\t")
              sVarBlank     = sVarBlank.gsub(TTJ_TAB, "")
              nVarBlankSize = sVarBlank.size()
              sVarBlank     = "#{(TTJ_TAB * nVarTabCount)}#{(TTJ_BLINK_INDEX * nVarBlankSize)}"

              val.each_value{|cVarInfo|
                if (cVarInfo.hMember.nil?() == false)  # ��¤�Τξ��(ref��)
                  sVar += "#{cVarInfo.sVarName}#{TTJ_PAUSE}#{GRP_TTJ_STATUS[cVarInfo.sType]}#{TTJ_NEW_LINE}"  # �ѿ�̾���ѿ��Υ�����

                  # ��¤�Τ�°���Υ���ǥ������
                  nBlankSizeTemp = 1

                  cVarInfo.hMember.each_key{|blankSizeKey|
                    if (nBlankSizeTemp < blankSizeKey.size())
                      nBlankSizeTemp = blankSizeKey.size()
                    end
                  }

                  # ��¤�Τ����ܸ첽
                  GRP_TTJ_STRUCT_SEQUENCE.each{|sStruct|
                    cVarInfo.hMember.each{|memKey, memVal|
                      if (sStruct == memKey)
                        sVar += "#{sVarBlank}#{TTJ_BLOCK_OPEN}#{memKey}#{(TTJ_BLINK_INDEX * (nBlankSizeTemp - memKey.size()))}#{TTJ_PARTITION}#{memVal}#{TTJ_BLOCK_CLOSE}#{TTJ_NEW_LINE}"  # ��¤�Τ���
                      end

                      if (GRP_TTJ_STRUCT_SEQUENCE.include?(memKey) == false)
                        $sAttrErr += "Struct [#{sObjectType} : #{memKey}] #{@sTestID}#{TTJ_NEW_LINE}"  # ���ꤵ��Ƥ��ʤ�°���Υ��顼����
                      end
                    }
                  }

                  sVar[sVar.rindex(TTJ_NEW_LINE)] = ""  # �Ǹ�β��Ԥ���
                  sVar = sVar.gsub(/, \}/, TTJ_BLOCK_CLOSE)
                else
                  # val��ʣ���ξ��ϳ�̤ǰϤ�Ƕ��̤���
                  if (val.size() > 1)
                    sVar += "#{TTJ_BLOCK_OPEN}"
                  end

                  sVar += "#{cVarInfo.sVarName}#{TTJ_PAUSE}#{GRP_TTJ_STATUS[cVarInfo.sType]}"  # �ѿ�̾���ѿ��Υ�����

                  if (cVarInfo.snValue.nil?() == false)
                    sVar += "#{TTJ_PAUSE}#{cVarInfo.snValue}"  # �ѿ�����
                  end

                  # val��ʣ���ξ��ϳ�̤ǰϤ�Ƕ��̤���
                  if (val.size() > 1)
                    sVar += "#{TTJ_BLOCK_CLOSE}"
                  end

                  sVar += "#{TTJ_NEW_LINE}#{sVarBlank}"
                end
              }

              sVar = sVar.gsub(/, \z/, "")
              sVar = sVar.gsub(/#{TTJ_NEW_LINE}#{sVarBlank}\z/, "")
              sVar = sVar.gsub("#{@sTestID}_", "")  # Alias���
              sReturnState += "#{blank(hAttribute[key])}#{sVar}"

            # sns_ker��do����
            when TSR_PRM_DO
              sVar = ""

              sDoIndent = "#{@sBlankIndent}#{(TTJ_BLINK_INDEX * (blank(hAttribute[key]).size() - 1))}"
              sVar = japanize_do(blank(hAttribute[key]), sDoIndent, val)

              sReturnState += "#{sVar}"

            # sns_ker��global����
            when TSR_PRM_GLOBAL
              sReturnState += "#{blank(hAttribute[key])}#{GRP_TTJ_STATUS[val][key][@hExistState[TSR_PRM_TYPE]]}"

            # ���ΰʳ���°�������ܸ��Ѵ�(���Ӥν������פ�ʤ�°��)
            else
              # val���� : prcid, wupcnt, tskpri, actprc, actcnt, bootcnt, pndptn, itskpri, cyctim,
              #           cycphs, exinf, texptn, procid, class, spinid, excno, intno, inhno, intpri
              #           maxsem, isemcnt, semcnt, maxmpri, flgptn, iflgptn, dtqcnt, maxdpri, pdqcnt,
              #           fblkcnt, blkcnt, lefttim, porder, lefttmo, blksz
              # GRP_TTJ_STATUS[val]������task
              if (GRP_TTJ_STATUS[val].nil?())
                val = val.to_s.gsub("#{@sTestID}_", "")  # Alias���
                sReturnState += "#{blank(hAttribute[key])}#{val}"
              elsif ((val == TSR_STT_TRUE) || (val == TSR_STT_FALSE))
                $sAttrErr += "[#{sObjectType} : #{key}°����#{val}] #{@sTestID}#{TTJ_NEW_LINE}"  # ���ꤵ��Ƥ��ʤ�°���Υ��顼����
              else
                sReturnState += "#{blank(hAttribute[key])}#{GRP_TTJ_STATUS[val]}"
              end
            end

            sReturnState += "#{TTJ_NEW_LINE}"
          end
        }
      }

      # ���ꤵ��Ƥ��ʤ�°���Υ��顼����
      aAttrErr= []

      GRP_TTJ_ATTRIBUTE.each{|hAttribute|
        aAttrErr.push(hAttribute.keys[0])
      }

      @hExistState.each{|key, val|
        if (aAttrErr.include?(key) == false)
          $sAttrErr += "[#{sObjectType} : #{key}] #{@sTestID}#{TTJ_NEW_LINE}"  # ���ꤵ��Ƥ��ʤ�°���Υ��顼����
        end
      }

      # �ƥ��֥������Ȥβ���
      sReturnState += "#{TTJ_NEW_LINE}"

      return sReturnState  # [String]�ƥ��֥������Ȥ����ܸ첽����ʸ����
    end

    #=================================================================
    # ������: do�ξ�������ܸ첽�����֤�
    #=================================================================
    def japanize_do(sAllDo, sIndent, hVal = nil)
      check_class(String, sAllDo)    # do�����������ݻ����Ƥ���
      check_class(String, sIndent)   # do�δ��ܥ���ǥ��
      check_class(Hash, hVal, true)  # ���do����ƤФ줺sns_ker����ƤФ줿���

      # do�ν������ܸ첽��������
      if (hVal.nil?() == true)
        hDoInfo = @hDo
        sAllDo += "#{sIndent}#{hDoInfo[TSR_PRM_ID]}��"
      else
        hDoInfo = hVal  # sns_ker�Υ��֥����������do�ν���
      end

      if (hDoInfo[TSR_PRM_CODE].nil?() == false)  # code
        sAllDo += "#{hDoInfo[TSR_PRM_CODE]}��¹Ԥ��롥"
      elsif (hDoInfo[TSR_PRM_ERUINT].nil?() == false)  # eruint
        if (hDoInfo[TSR_PRM_ERUINT].is_a?(Integer) == false)  # eruint�����顼�����ɤξ��
          sAllDo += "#{hDoInfo[TSR_PRM_SYSCALL]}��ȯ�Ԥ���#{TTJ_NEW_LINE}"
          sAllDo += "#{sIndent}���顼�����ɤȤ���#{hDoInfo[TSR_PRM_ERUINT]}���֤롥"
        else
          sAllDo += "#{hDoInfo[TSR_PRM_SYSCALL]}��ȯ�Ԥ���#{TTJ_NEW_LINE}"
          sAllDo += "#{sIndent}�����塼���󥰿��Ȥ���#{hDoInfo[TSR_PRM_ERUINT]}���֤롥"
        end
      elsif (hDoInfo[TSR_PRM_BOOL].nil?() == false)  # bool
        sAllDo += "#{hDoInfo[TSR_PRM_SYSCALL]}��ȯ�Ԥ���#{TTJ_NEW_LINE}"
        sAllDo += "#{sIndent}���ȷ�̤Ȥ���#{hDoInfo[TSR_PRM_BOOL]}���֤롥"
      elsif (hDoInfo[TSR_PRM_ERCD].nil?() == false)  # ercd
        sAllDo += "#{hDoInfo[TSR_PRM_SYSCALL]}��ȯ�Ԥ���#{TTJ_NEW_LINE}"
        sAllDo += "#{sIndent}���顼�����ɤȤ���#{hDoInfo[TSR_PRM_ERCD]}���֤롥"
      else
        sAllDo += "#{hDoInfo[TSR_PRM_SYSCALL]}��ȯ�Ԥ��롥"
      end

      if (hDoInfo[TSR_PRM_GCOV].nil?() == false)  # gcov
        sAllDo += "#{TTJ_NEW_LINE}#{sIndent}#{TSR_PRM_GCOV}��#{GRP_TTJ_STATUS[hDoInfo[TSR_PRM_GCOV]][TSR_PRM_GCOV]}"
      end

      sAllDo = sAllDo.gsub("#{@sTestID}_", "")  # Alias���

      return sAllDo  # [String]do�����ܸ첽����ʸ����
    end

    #=================================================================
    # ������: Blank�Υ�������׻�����
    #=================================================================
    def blank_size(sAttr)
      check_class(String, sAttr)  # ���֥������Ȥγ���°��

      if (@nBlankSize < sAttr.size())
        @nBlankSize = sAttr.size()
      end
    end

    #=================================================================
    # ������: °����Ĺ�����碌�뤿��˥���ǥ�Ȥ�������֤�
    #=================================================================
    def blank(sAttr)
      check_class(String, sAttr)  # ���֥������Ȥγ���°��

      sRetAtt = "#{@sBlankIndent}#{sAttr}"

      (@nBlankSize - sAttr.size()).times{
        sRetAtt += "#{TTJ_BLINK_INDEX}"
      }

      sRetAtt += "#{TTJ_PARTITION}"

      return sRetAtt  # [String]°����Ĺ�����碌��ʸ����
    end

  end
end
